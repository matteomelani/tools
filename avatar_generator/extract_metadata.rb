# input: path to a directory containing images(jpg or png), a file name
# output: a file containing a list of maps in yaml format

images_dir = ARGV[0]
images_dir = File.absolute_path(ARGV[0])
unless File.exists?(images_dir) || File.directory?(images_dir)
  puts "Looks like #{images_dir} does not exists or is not a dir!"
  exit
end

metadata = {}
Dir.new(images_dir).entries.each do |f| 
  unless File.extname(f).downcase == ".png" || File.extname(f).downcase == ".jpg" || File.extname(f).downcase == ".jpeg"
    puts "#{f} is not an image. Skipping it!"
    next
  end
  if File.directory?(f)
    puts "#{f} is a dir. Skipping it!"
    next
  end
  puts "Extracting metadata for #{f}."
  metadata[f] = {
            :name=>f,
            :asset_file_name=>f, 
            :asset_content_type=>"image/#{File.extname(f).delete('.')}",
            :asset_file_size=>File.size(images_dir+"/"+f)
        }
end

require 'yaml'
File.open(File.absolute_path(ARGV[1]), "w") do |f|
  f.puts metadata.to_yaml
end
   