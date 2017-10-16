require 'sinatra'
require_relative './graph.rb'

graph = Graph.new('data.json')


get '/actors' do
  puts request.query_string
  # attr = params['splat'][0]
  # val = params['splat'][1]
  # graph.actors.each do |actor|
  #   if actor.attr == val
  #
  #   end
  # end
end

get '/movies?' do

end

get '/actors/' do

end

get '/movies/' do

end

put '/actors' do

end

put '/movies' do

end

post '/actors' do

end

post '/movies' do

end

delete '/actors' do

end

delete '/movies' do

end