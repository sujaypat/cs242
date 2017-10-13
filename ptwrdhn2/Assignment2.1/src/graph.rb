require 'test-unit'
require 'set'
class Graph

  attr_accessor :movies
  attr_accessor :actors
  attr_accessor :actor_set
  attr_accessor :movie_set

  def initialize
    @actor_set = Set.new
    @movie_set = Set.new
    @movies = Array.new
    @actors = Array.new
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

  def initialize(name, age)
    @name = name
    @age = age
    @gross = 0
    @movie_connections = Array.new
  end

end