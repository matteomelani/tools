require 'nokogiri'
require 'open-uri'


url="http://www.greatschools.org/search/search.page?c=school&q=94025&state=CA"
print "\n\n\nScraping #{url} ...\n\n"
doc = Nokogiri::HTML(open(url))
school_list = []
search_results = doc.css('tr.school-search-result-row')
search_results.each do |sd|
  school_data ={}
  school_data[:name] = Nokogiri::HTML(sd.to_s).css('td .js-school-search-result-name')[0].text
  school_data[:type] = Nokogiri::HTML(sd.to_s).css('td .text3 span')[0].text
  school_data[:grade] = Nokogiri::HTML(sd.to_s).css('td .text3 span+span')[0].text
  school_data[:street] = Nokogiri::HTML(sd.to_s).css('td .js-school-search-result-street')[0].text
  school_data[:citystatezip] = Nokogiri::HTML(sd.to_s).css('td .js-school-search-result-citystatezip')[0].text
  school_data[:phone] = Nokogiri::HTML(sd.to_s).css('td .js-school-search-result-phone')[0].text
  print school_data
  print "\n\n"
end
print search_results.count
print "\n\nDone!\n\n"

