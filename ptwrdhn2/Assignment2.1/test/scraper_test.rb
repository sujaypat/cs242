require 'test-unit'
require_relative '../src/scraper'

class Scraper_Test < Test::Unit::TestCase


  def test_simple
    scr = Scraper.new('https://en.wikipedia.org/wiki/Top_Gun')
    puts "actors: " + scr.graph.actors.length.to_s
    puts "movies: " + scr.graph.movies.length.to_s
    assert(scr.graph.movies.length >= 15)
    assert(scr.graph.actors.length >= 25)
  end

  def test_json
    scr = Scraper.new('https://en.wikipedia.org/wiki/Top_Gun')
    puts "actors: " + scr.graph.actors.length.to_s
    puts "movies: " + scr.graph.movies.length.to_s
    scr.dump_json
  end

  def test_money
    scr = Scraper.new('https://en.wikipedia.org/wiki/Top_Gun')

    assert(scr.parse_money("$10 million") == 10000000.0)
    assert(scr.parse_money("$10 billion") == 10000000000.0)

  end

  def test_fail_url
    begin
      scr = Scraper.new('https://fake.website')

    rescue SocketError
    end
  end


end