require 'test/unit'

class Graph_Test < Test::Unit::TestCase

  def test_add_movies
    graph = Graph.new
    graph.movie_insert(Movie.new("test movie", 1000000, 1900))
    assert(graph.movies_year(1900).length == 1)
    assert(graph.gross("test movie") == 1000000)
  end

  def test_add_actors
    graph = Graph.new
    graph.actor_insert(Actor.new("test actor", 100))
    assert(graph.topn_old(1).length == 1)
    assert(graph.actor_movies("test actor").length == 0)
  end

  def test_json
    graph = Graph.new
    puts "actors: " + graph.actors.length.to_s
    puts "movies: " + graph.movies.length.to_s
    graph.dump_json
  end

end