require './scraper'
class Driver
  def initialize
    # scraper = Scraper.new('https://en.wikipedia.org/wiki/Brad_Pitt')
      graph = Graph.new('data.json')
      graph.analyze_hub



  end

end

d = Driver.new