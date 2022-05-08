require 'sinatra'
require 'sinatra/reloader' if settings.development?
require 'sinatra/flash'
require 'json'
require 'net/http'

Org ||= Struct.new(:id, :user_id, :name, keyword_init: true)

def fetch_all_orgs
  [
    Org.new(id: 1, user_id: 1, name: '株式会社blue'),
    Org.new(id: 2, user_id: 1, name: '株式会社red'),
    Org.new(id: 3, user_id: 2, name: '株式会社yellow'),
  ]
end

def search_orgs(user_id)
  fetch_all_orgs.select { |org| org.user_id == user_id }
end

get '/health' do
  'OK'
end

get '/api/users/:user_id/orgs' do
  search_orgs(params[:user_id].to_i).map(&:to_h).to_json
end
