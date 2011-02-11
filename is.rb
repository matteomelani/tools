require 'rubygems'
require 'csv'
require 'open-uri'



issue_list='/Users/matteo/Desktop/issue2.csv'
dest_dir = "/Users/matteo/pubblications"
   
puts "Reading csv file: #{issue_list}"
reader = CSV.open(issue_list, 'r')

puts "Downloading issues..."
i=0
reader.each do |row|
  
  # skip the first row since it contains the columns' names
   if (i==0)
     i+=1
     next
   end
  
   puts "-----   Processing row #{i}   -----" 
   
   # of each column we care about the pubblication id, issue id and url 
   # of the pdf to download.
   publication_id = row[0]
   issue_id = row[1]
   pdf_url = row[2]
   issue_id_comps = row[1].split("/")
   
   # reformat the issue id in ISO-XXXX
   issue_id= "20#{issue_id_comps[2]}-#{issue_id_comps[0]}-#{issue_id_comps[1]}"
   
   puts "#{publication_id}/#{issue_id} => #{pdf_url}"
   
   puts "Dowloading issue..."
   url_cont = open(pdf_url)
   file_str = url_cont.read
   puts "done!"
   
   puts "Building target file..."
   dest_base_dir = File.expand_path("#{dest_dir}/#{publication_id}")
   Dir.mkdir(dest_base_dir) if Dir.exist?(dest_base_dir) == false
   dest_file_path = File.join(dest_base_dir,"#{issue_id}.pdf")
   puts "   Target file: #{dest_file_path}"
   dest_file = open(dest_file_path, "w")
   dest_file.write(file_str)     

   puts "         -----------------          "
   puts
   
   i+=1 # increment counter
   
end
