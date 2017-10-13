require 'test-unit'
require_relative '../src/scrape_log'

class ScrapeLog_Test < Test::Unit::TestCase

  def test_levels
    sc = ScrapeLog.new('test_messages.log')
    sample_msg = "THIS IS A TEST"

    sc.info(sample_msg)
    sc.error(sample_msg)
    sc.warning(sample_msg)

    f = File.open('../test_messages.log', 'r')
    puts f.read
    f.close

  end

end