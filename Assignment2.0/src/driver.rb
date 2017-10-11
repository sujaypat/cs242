require './scraper'
class Driver
  def initialize
    scraper = Scraper.new('https://en.wikipedia.org/wiki/Top_Gun')

    puts scraper.graph.movies_year(1986).length
    puts scraper.graph.movie_actors("Top Gun")
    puts scraper.graph.movie_actors("Tom Cruise")
    puts scraper.graph.gross("Top Gun")

    scraper.dump_json
    scraper.read_json

  end

end

d = Driver.new