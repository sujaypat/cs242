require './scraper'
class Driver
  def initialize
    scraper = Scraper.new('https://en.wikipedia.org/wiki/Top_Gun')
    scraper.dump_json
    scraper.read_json
    printf("asdfasdfasdf: ")
  end

end

d = Driver.new