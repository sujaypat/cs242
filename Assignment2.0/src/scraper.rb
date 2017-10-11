require 'test-unit'
require 'nokogiri'
require 'json'
require 'httparty'

require 'net/http'
require_relative 'scrape_log.rb'
require_relative 'graph.rb'

$ACTOR_LIMIT = 125
$MOVIE_LIMIT = 250

class Scraper


  @@logger = ScrapeLog.new('messages.log')
  @@task_queue = Queue.new # enq for push, deq for pop
  @@graph = Graph.new


  def initialize(url)
    @@task_queue.enq(url)
    scrape
  end

  def scrape
    until @@graph.movies.length >= $MOVIE_LIMIT and @@graph.actors.length >= $ACTOR_LIMIT
      if @@task_queue.length == 0
        return
      end
      curr_url = @@task_queue.deq
      if curr_url[0] != 'h'
        curr_url = 'https://en.wikipedia.org' + curr_url.to_s
      end

      @@logger.info("analyzing page:" + curr_url.to_s)
      page = HTTParty::get(curr_url)
      # error check page
      if page == nil
        @@logger.error("unable to get page " + curr_url.to_s)
        return
      end
      source = Nokogiri::HTML(page)
      # error check source
      if page == nil
        @@logger.error("unable to get source for " + curr_url.to_s)
        return
      end
      parse(source)

    end
    puts @@task_queue
  end

  def parse(source)
    right_box = source.css('.vevent')
    begin
      title = source.xpath('//div[@id="content"]/h1[@id="firstHeading"]').text.to_s
      puts title
      movie_gross = parse_money(right_box.css('td:contains("$")').last.text.strip)
      year = Date.parse(right_box.css('span.bday.dtstart.published.updated').text).year
      starring = source.xpath('//div[@id="mw-content-text"]/div[@class="mw-parser-output"]/ul[1]/li/a[1]')

      new_movie = Movie.new(title, movie_gross, year)

      @cast = Array.new

      for link in starring
        @cast << link.attribute('title').to_s
        @@task_queue << link.attribute('href').to_s
        new_movie.actor_connections << link.attribute('title').to_s
      end
      @@graph.movie_insert(new_movie)

    rescue NoMethodError
    end

    begin
      name = source.xpath('//h1[@id="firstHeading"]').to_s
      age = source.xpath('//tbody/tr[3]/td/span[@class="noprint ForceAgeToShow"]').text.to_s
      filmography = source.xpath('//div[@id="mw-content-text"]/div[@class="mw-parser-output"]/div[@class="div-col columns column-count column-count-2"]/ul')

      new_actor = Actor.new(name, age)

      @films = Array.new

      for link in filmography
        @films << link.attribute('title').to_s
        puts link.attribute('title').to_s
        @@task_queue << link.attribute('href').to_s
        new_actor.movie_connections << link.attribute('title').to_s
      end
      @@graph.actor_insert(new_actor)

    rescue NoMethodError

    end

  end

  def dump_json
    puts "dumping json"
    jsonified_movies = @@graph.movies.to_json
    jsonified_actors = @@graph.actors.to_json
    File.open('../movies.json', 'w'){ |f| f << jsonified_movies}
    File.open('../actors.json', 'w'){ |f| f << jsonified_actors}
  end

  def read_json
    #@graph.@movies =
    puts JSON.parse(File.read('../movies.json'))
    # @graph.@actors = JSON.parse(File.read('actors.json'))
  end

  def parse_money(str)
    money_split = str.split(" ")
    @value = money_split[0][1..money_split[0].length].to_f
    if money_split[1].include? "million"
      @value *= 1000000
    elsif money_split[1].include? "billion"
      @value *= 1000000000
    end

    return @value
  end

end