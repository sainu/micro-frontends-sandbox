require 'sinatra'
require 'sinatra/reloader' if settings.development?

get '/health' do
  'OK'
end

get '/' do
  erb :index
end

get '/callback' do
  # TODO: login
  redirect '/'
end

post '/logout' do
  # TODO: logout
end
