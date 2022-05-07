require 'sinatra'
require 'sinatra/reloader' if settings.development?
require 'rack/flash'
require 'logger'
require 'json'

set :sessions, domain: 'auth.lvh.me'
use Rack::Flash

logger = Logger.new(STDOUT)
User = Struct.new('User', :id, :name, keyword_init: true)
LoginForm = Struct.new('LoginForm', :name, :redirect_url, :error, keyword_init: true)

def fetch_users
  @users ||= [
    User.new(id: 1, name: '佐藤 一'),
    User.new(id: 2, name: '山田 太郎')
  ]
end

before do
  @current_user = fetch_users.find { |user| session[:user_id] == user.id }
  @user_signed_in = !!@current_user
end

get '/health' do
  'OK'
end

get '/' do
  erb :index
end

get '/login' do
  if @user_signed_in
    flash[:notice] = 'すでにログインしています'
    redirect '/'
  end

  @users = fetch_users
  @form = LoginForm.new(redirect_url: params[:redirect_url])
  erb :login
end

post '/login' do
  if @user_signed_in
    flash[:notice] = 'すでにログインしています'
    redirect '/'
  end

  @form = LoginForm.new(name: params[:name], redirect_url: params[:redirect_url])

  @users = fetch_users
  user = @users.find { |u| u.name == @form.name }
  unless user
    @form.error = true
    return erb :login
  end

  session[:user_id] = user.id

  if @form&.redirect_url
    # You must prevent open redirect attacks in the production environment
    redirect "#{@form.redirect_url}?user_id=#{user.id}"
  else
    flash[:notice] = 'ログインしました'
    redirect '/'
  end
end

post '/logout' do
  session[:user_id] = nil

  flash[:notice] = 'ログアウトしました'
  redirect '/'
end

get '/oauth/authz' do
  redirect_url = params[:redirect_url]

  if params[:prompt] == 'login'
    session[:user_id] = nil
    redirect "/login?redirect_url=#{redirect_url}"
  elsif params[:prompt] == 'none' && @user_signed_in
    redirect redirect_url
  else
    redirect "/login?redirect_url=#{redirect_url}"
  end
end

get '/oauth/end_session' do
  redirect_url = params[:redirect_url]
  session[:user_id] = nil
  redirect redirect_url
end

get '/api/users/:id' do
  user = fetch_users.find { |u| u.id == params[:id].to_i }
  user.to_h.to_json
end
