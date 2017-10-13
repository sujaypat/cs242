require 'test-unit'
require 'time'

class ScrapeLog

  # open/create the file
  def initialize(filename)
    @@filename = filename
    File.open('../' + filename, 'a')
  end


  def error(msg)
    File.open('../' + @@filename, 'a') {|file| file.write('ERROR: ' + Time.now.inspect + ' ' + msg + "\n")}
  end

  def warning(msg)
    File.open('../' + @@filename, 'a') {|file| file.write('WARN: ' + Time.now.inspect + ' ' + msg + "\n")}
  end

  def info(msg)
    File.open('../' + @@filename, 'a') {|file| file.write('INFO: ' + Time.now.inspect + ' ' + msg + "\n")}
  end
end