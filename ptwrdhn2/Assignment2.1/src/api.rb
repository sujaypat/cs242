require 'sinatra'
require 'json'
require_relative './graph.rb'

graph = Graph.new('data.json')


get '/actors' do
  req = request.query_string
  result = graph.actors.dup
  ands = req.split("&")
  ands.each do |clause|
    temp = Array.new
    ors = clause.split("|")
    ors.each do |o_clause|
      parts = o_clause.split("=")
      if parts[0] == "name"
        temp |= graph.get_actor_name(parts[1])
      elsif parts[0] == "gross"
        temp |= graph.get_actor_gross(parts[1])
      elsif parts[0] == "age"
        temp |= graph.get_actor_age(parts[1])
      end
    end
    result &= temp
  end
  return result.map do |actor| actor.to_json end
end

get '/movies' do
  req = request.query_string
  result = graph.movies.dup
  ands = req.split("&")
  ands.each do |clause|
    temp = Array.new
    ors = clause.split("|")
    ors.each do |o_clause|
      parts = o_clause.split("=")
      if parts[0] == "name"
        temp |= graph.get_movie_name(parts[1])
      elsif parts[0] == "gross"
        temp |= graph.get_movie_gross(parts[1])
      elsif parts[0] == "year"
        temp |= graph.movies_year(parts[1])
      end
    end
    result &= temp
  end
  return result.map do |movie| movie.to_json end
end

get '/actors/:name' do
  # loop through actors list until we find this name and print all data fields
  graph.actors.each do |actor|
    if actor.name.casecmp(params['name'].gsub(/_/, ' ')) == 0
      status 200
      return actor.to_json
    end
  end
  status 404
end

get '/movies/:title' do
  # loop through movies list until we find this title and print all data fields
  graph.movies.each do |movie|
    if movie.title.casecmp(params['title'].gsub(/_/, ' ')) == 0
      status 200
      return movie.to_json
    end
  end
  status 404
end

put '/actors/:name' do
  # find name and update relevant data field
  request_payload = JSON.parse(request.body.read)
  graph.actors.each do |actor|
    if actor.name.casecmp(params['name'].gsub(/_/, ' ')) == 0
      begin
        name = request_payload['name']
        gross = request_payload['total_gross']
        age = request_payload['age']
        actor.name = name ? name : actor.name
        actor.gross = gross ? gross : actor.gross
        actor.age = age ? age : actor.age
        status 200
        return
      end
    end
  end
  status 404
end

put '/movies/:title' do
  # find title and update relevant data field
  request_payload = JSON.parse(request.body.read)
  graph.movies.each do |movie|
    if movie.title.casecmp(params['title'].gsub(/_/, ' ')) == 0
      begin
        title = request_payload['title']
        gross = request_payload['box_office']
        year = request_payload['year']
        movie.title = title ? title : movie.title
        movie.gross = gross ? gross : movie.gross
        movie.year = year ? year : movie.year
        status 200
        return
      end
    end
  end
  status 404

end

post '/actors' do
  request_payload = JSON.parse(request.body.read)
  begin
    name = request_payload['name']
    gross = request_payload['total_gross']
    age = request_payload['age']
    new_actor = Actor.new(name ? name : '', gross ? gross : 0, age ? age : 0)
    graph.actors << new_actor
    graph.actor_set << new_actor
    status 201
    return
  end
  status 400
end

post '/movies' do
  request_payload = JSON.parse(request.body.read)
  begin
    title = request_payload['name']
    box_office = request_payload['box_office']
    year = request_payload['year']
    new_movie = Actor.new(title ? title : '', box_office ? box_office : 0, year ? year : 0)
    graph.movies << new_movie
    graph.movie_set << new_movie
    status 201
    return
  end
  status 400
end

delete '/actors/:name' do
  # loop through, find and delete actor
  graph.actor_set.each do |actor|
    if actor.name.casecmp(params['name'].gsub(/_/, ' ')) == 0
      graph.actors.delete(actor)
      graph.actor_set.delete(actor)
      status 200
      return
    end
  end
  status 404
end

delete '/movies/:title' do
  # loop through, find and delete movie
  graph.movie_set.each do |movie|
    if movie.title.casecmp(params['title'].gsub(/_/, ' ')) == 0
      graph.movies.delete(movie)
      graph.movie_set.delete(movie)
      status 200
      return
    end
  end
  status 404
end