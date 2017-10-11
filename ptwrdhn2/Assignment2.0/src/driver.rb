require './scraper'
class Driver
  def initialize
    scraper = Scraper.new('https://en.wikipedia.org/wiki/Brad_Pitt')

    puts scraper.graph.movies_year(1991)[0].title
    # puts scraper.graph.movie_actors("")
    puts scraper.graph.actor_movies("Brad Pitt")[0]
    puts scraper.graph.topn_old(5)[0].name

    scraper.dump_json
    scraper.read_json

  end

end

d = Driver.new