require 'sinatra'
require 'sinatra/reloader' if settings.development?
require 'sinatra/flash'
require 'json'
require 'net/http'

set :sessions, domain: 'app1.lvh.me'

User = Struct.new('User', :id, :name, keyword_init: true)

def fetch_user(id)
  uri = URI.parse("http://auth:3000/api/users/#{id}")
  response = Net::HTTP.get_response(uri)
  User.new(**JSON.parse(response.body))
end

before do
  @current_user = session[:user_id] ? fetch_user(session[:user_id]) : nil
  @user_signed_in = !!@current_user
end

get '/health' do
  'OK'
end

get '/' do
  erb :index
end

get '/callback' do
  user = fetch_user(params[:user_id])
  session[:user_id] = user.id
  flash[:notice] = 'ログインしました'
  redirect '/'
end

post '/logout' do
  # TODO: logout
end
