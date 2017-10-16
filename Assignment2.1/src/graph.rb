require 'test-unit'
require 'set'
require 'gruff'
class Graph

  attr_accessor :movies
  attr_accessor :actors
  attr_accessor :actor_set
  attr_accessor :movie_set

  def initialize(filename)
    @actor_set = Set.new
    @movie_set = Set.new
    @movies = Array.new
    @actors = Array.new
    read_json(filename)
  end

  def actor_insert(actor)
    actors << (actor)
    for m in movies # every movie, if actor in movie add actor to movie connections
        # and add movie to actor's connections
      if m.actor_connections.contains? actor.name
        actor.movie_connections << m
      end
    end
  end

  def movie_insert(movie)
    movies << (movie)
    for a in actors # every movie, if actor in movie add actor to movie connections
      # and add movie to actor's connections
      if a.movie_connections.contains? movie.title
        movie.actor_connections << a
      end
    end
  end

  # Iterate through list of movies, find matching name and return gross value
  def gross(movie_name)
    for m in movies
      if m.title == movie_name
        return m.gross
      end
    end
    return -1
  end

  def topn_gross(n)
    # sort by gross, slice top n
    movies.sort_by(&:gross).last(n)
  end

  def topn_old(n)
    # sort by age, slice top n
    actors.sort_by(&:age).last(n)
  end

  def actor_movies(actor_name)
    # return all movies connected by an edge to actor
    for a in actors
      if a.name == actor_name
        return a.movie_connections
      end
    end
    return nil
  end

  def movie_actors(movie_name)
    # same as above but the other way around
    for m in movies
      if m.title == movie_name
        return m.actor_connections
      end
    end
    return nil
  end

  def movies_year(year)
    # add all movies from year to list
    result = Array.new
    for m in movies
      if m.year == year
        result << m
      end
    end
    return result
  end

  def actors_year(year)
    movies_for_year = movies_year(year)
    result = Array.new
    for m in movies_for_year
      for a in m.actor_connections
        result << a
      end
    end
    # add all actors from each movie in movies_year to list
    return result
  end


  # counts the number of connections each actor has and sorts it, and filters the top 5
  def analyze_hub
    names = {}
    labels = {}

    actors.each do |actor|
      count = 0
      actor.movie_connections.each do |movie|
        count += movie.actor_connections.length
      end
      names[actor.name] = count
    end
    names = names.sort_by{|k,v| v}.reverse[0..5]

    iter = -1
    names.each do |k,v|
      labels[iter+=1] = k
    end

    g = Gruff::Bar.new('1600x900')
    g.label_stagger_height = 20
    g.sort = false
    g.title = 'hub actors'
    g.labels = labels
    g.data('data',names.collect { |k, v| v })
    g.write('hub.png')
  end

  def analyze_age_gross
    ages = {}
    grosses = {}


    g = Gruff::Line.new('1600x900')

  end



  def dump_json
    # puts "dumping json"
    jsonified_movies = graph.movies.to_json
    jsonified_actors = graph.actors.to_json
    File.open('../movies.json', 'w'){ |f| f << jsonified_movies}
    File.open('../actors.json', 'w'){ |f| f << jsonified_actors}
  end

  def read_json(filename)
    all_json = JSON.parse(File.read('../' + filename))
    actors = all_json[0]
    movies = all_json[1]

    actors.each do |_, value|
      temp_actor = Actor.new(value["name"], value["total_gross"], value["age"])
      value["movies"].each do |movie_title|
        begin
        temp_movie = Movie.new(movies[movie_title], movies[movie_title]["box_office"], movies[movie_title]["year"])
        if !@movie_set.include? temp_movie
          @movies << temp_movie
          @movie_set << temp_movie
        end
        temp_actor.movie_connections << temp_movie
        temp_movie.actor_connections << temp_actor
        rescue => error
          # puts error
        end
      end
      # puts temp_actor.movie_connections.length
      @actors << temp_actor
      @actor_set << temp_actor
    end
  end

end

class Movie
  attr_accessor :title
  attr_accessor :gross
  attr_accessor :year
  attr_accessor :actor_connections

  def initialize(title, gross, year)
    @title = title
    @gross = gross
    @year = year
    @actor_connections = Array.new
  end

end

class Actor
  attr_accessor :name
  attr_accessor :age
  attr_accessor :gross
  attr_accessor :movie_connections

  def initialize(name, gross, age)
    @name = name
    @age = age
    @gross = gross
    @movie_connections = Array.new
  end

end