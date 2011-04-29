require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'geokit'

i=0
school_data_hash ={}
target_city = [ "menlo park", "palo alto" ]
target_city.each  do |city|

  print "scraping school data for: #{city}.\n"
  url = sprintf("http://www.greatschools.org/search/search.page?c=school&q=%s&state=CA&pageSize=100", city.strip.upcase.sub(' ', "+"))
  print "scraping #{url} ..."
  doc = Nokogiri::HTML(open(url))
  search_results = doc.css('tr.school-search-result-row')
  search_results.each do |sd|
    school_data ={}
    school_data[:name] = Nokogiri::HTML(sd.to_s).css('td .js-school-search-result-name')[0].text.strip
    school_data[:category] = Nokogiri::HTML(sd.to_s).css('td .text3 span')[0].text.downcase.strip
    school_data[:grade_range] = Nokogiri::HTML(sd.to_s).css('td .text3 span+span')[0].text.downcase.strip
    citystatezip = (Nokogiri::HTML(sd.to_s).css('td .js-school-search-result-citystatezip')[0].text).split(',')
    statezip = citystatezip[1].split(' ')

    address = {
      :street  => Nokogiri::HTML(sd.to_s).css('td .js-school-search-result-street')[0].text,
      :city    => citystatezip[0].strip,
      :state   => statezip[0].strip,
      :zipcode => statezip[1].strip.to_i
      }
    address[:geolocation] = Geokit::Geocoders::GoogleGeocoder.geocode("#{address[:street]}, #{address[:city]}, #{address[:state]}")
    school_data = school_data.merge :address=>address, :phone_number=>"" 
    school_data_hash[i] = school_data
    i += 1
  end
  puts "done.\n"
  print "scrapted data for #{search_results.count} #{city} schools.\n"   
end

print "gather data for #{school_data_hash.size} school in total.\n"
output_file = "school_data.yaml"
f = File.open(output_file, "w")
print "writing data to file: #{File.absolute_path(f)} ..." 
f.puts school_data_hash.to_yaml
f.close
puts "done.\n"
print "good-bye.\n\n"