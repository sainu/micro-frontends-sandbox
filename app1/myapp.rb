require 'sinatra'
require 'sinatra/reloader' if settings.development?
require 'sinatra/flash'
require 'json'
require 'net/http'
require 'logger'

use Rack::Session::Pool,
  secret: 'super secret',
  http_only: true,
  domain: 'app1.lvh.me',
  expire_after: 60
use Rack::Protection::AuthenticityToken

logger = Logger.new(STDOUT)
User = Struct.new('User', :id, :name, keyword_init: true)
Org ||= Struct.new('Org', :id, :user_id, :name, keyword_init: true)
SelectOrgForm ||= Struct.new('SelectOrgForm', :org_id, keyword_init: true)

def fetch_user(id)
  uri = URI.parse("http://auth:3000/api/users/#{id}")
  response = Net::HTTP.get_response(uri)
  User.new(**JSON.parse(response.body))
end

def fetch_org(user_id, org_id)
  uri = URI.parse("http://org:3000/api/users/#{user_id}/orgs/#{org_id}")
  response = Net::HTTP.get_response(uri)
  Org.new(**JSON.parse(response.body))
end

def fetch_orgs(user_id)
  uri = URI.parse("http://org:3000/api/users/#{user_id}/orgs")
  response = Net::HTTP.get_response(uri)
  JSON.parse(response.body).map { |org| Org.new(**org) }
end

before do
  @current_user = session[:user_id] ? fetch_user(session[:user_id]) : nil
  @user_signed_in = !!@current_user
  @current_org = @user_signed_in && session[:org_id] ? fetch_org(@current_user.id, session[:org_id]) : nil
  @org_signed_in = !!@current_org
end

get '/health' do
  'OK'
end

get '/' do
  unless @user_signed_in
    redirect 'http://lp.lvh.me/app1.html'
  end
  unless @org_signed_in
    redirect '/select_org'
  end

  erb :index
end

get '/callback' do
  user = fetch_user(params[:user_id])
  session[:user_id] = user.id
  redirect '/'
end

post '/logout' do
  session[:user_id] = nil
  session[:org_id] = nil
  redirect 'http://auth.lvh.me/oauth/end_session?redirect_url=http://lp.lvh.me/app1.html'
end

get '/select_org' do
  unless @user_signed_in
    redirect 'http://lp.lvh.me/app1.html'
  end
  @orgs = fetch_orgs(@current_user.id)
  erb :select_org
end

post '/select_org' do
  unless @user_signed_in
    redirect 'http://lp.lvh.me/app1.html'
  end
  unless params[:org_id]
    @error = '組織を選択してください'
    @orgs = fetch_orgs(@current_user.id)
    return erb :select_org
  end
  org = fetch_org(@current_user.id, params[:org_id])
  session[:org_id] = org.id
  redirect '/'
end
