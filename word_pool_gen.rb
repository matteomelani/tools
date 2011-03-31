require 'rubygems'
require 'yaml'
require 'nokogiri'

# CONFIG_FILE = YAML::load(ERB.new(IO.read(ABACUS_CONFIG_FILEPATH)).result)


def is_noun?(word_definition)
  word_definition.start_with?("n.")
end

def is_adjective?(word_definition)
  word_definition.start_with?("adj.")
end


input_xdxf = "./english_dic.xml"
output_filename = "./words_bag-en.yaml"
black_list_filename = "./black_list.yaml"
key_filter = /^[a-z][^\(\-\s\']{3,4}$/
locale = :en

black_list_hash = YAML::load(File.read(black_list_filename))
black_list_array = black_list_hash[locale.to_s].split(" ")
black_list_hash2 = {}
black_list_array.each do |blw|
  black_list_hash2[blw]=blw 
end

f = File.open(input_xdxf)
doc = Nokogiri::XML::Document.parse(f)
words_bag = { locale => { :nouns => [], :adjectives => [] } }
doc.css('ar').each_with_index do |ar,i|
  k = ar.css('k').xpath('text()').to_s.strip.downcase
  v = ar.xpath('text()').to_s.strip
  if k.match(key_filter) && !black_list_hash2.key?(k)
    if is_noun?(v)  
      words_bag[locale][:nouns] << k
    elsif is_adjective?(v)    
      words_bag[locale][:adjectives] << k
    else
      #do nothing
    end
  end  
end
f.close

puts "Stats:"
puts "  n.   in words_bag: #{words_bag[locale][:nouns].size}"
puts "  adj. in words_bag: #{words_bag[locale][:adjectives].size}"
puts "  total number of combinations: #{words_bag[locale][:nouns].size*words_bag[locale][:adjectives].size}"

output_file = File.open(output_filename, "w")
output_file.puts words_bag.to_yaml
output_file.close

def test_generate_random_name(words_bag_file_path)
  words_bag_hash = YAML::load(File.read(words_bag_file_path))
  words_bag_hash_loc = words_bag_hash[:en]
  r = Random.new(Time.now.to_i)

  10.times do |i|
    adj_list  = words_bag_hash_loc[:adjectives]
    noun_list = words_bag_hash_loc[:nouns]
    adj_index = r.rand(0..adj_list.size)
    n_index = r.rand(0..noun_list.size)
    random_int = r.rand(0..1000)
    print "#{adj_list[adj_index]}-#{noun_list[n_index]}-#{random_int}\n"
  end
end