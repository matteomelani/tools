require 'open-uri'
require 'nokogiri'

while 1 do
  urls =  ['http://demo.theschoolcircle.com', 'http://staging.theschoolcircle.com']
  urls.each do |u| 
    begin
      print "Getting #{u}...."
      beginning = Time.now
      doc = Nokogiri::HTML(open(u))
      print "done in #{Time.now - beginning} seconds\n"
      sleep(2)
    rescue
      puts $!
      sleep(5)
    end
  end
end