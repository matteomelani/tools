### Source Dir
dir_path = ARGV.first
unless dir_path
  puts "\n\nYou must enter a directory path."
  puts "Bye!\n\n"
  exit 
end
dir_path = File.absolute_path dir_path
unless ( File.exists?(dir_path) or File.directory?(dir_path) ) 
  puts "\n\nCannot find directory #{dir_path}"
  puts "Bye!"
  exit
end
dir = Dir.new(dir_path)
puts "Source dir: #{dir_path}"

### Destination Dir
new_dir_path = ARGV[2]
unless new_dir_path
  new_dir_path = dir_path + "/images"
end
puts "Destination dir: #{new_dir_path}"
if File.exists?(new_dir_path)
  puts "Destination dir already exists!"
  exit
end
new_dir = Dir.mkdir(new_dir_path) 


### Process images
puts "Processing images (jpg) in directory #{dir_path}"
dir.entries.each_with_index do |f, index|
  f_path = File.absolute_path "#{dir_path}/#{f}"
  f_ext  = File.extname "#{f}"
  f_name = File.basename "#{f}", f_ext
  if ".jpg" == File.extname("#{f}").downcase
     output = `convert #{f_path} #{new_dir_path}/#{f_name}_original.png`
     output = `convert #{f_path} -thumbnail 32x32\^ -gravity center -extent 32x32 #{new_dir_path}/#{f_name}_small.png`
     output = `convert #{f_path} -thumbnail 48x48\^ -gravity center -extent 48x48 #{new_dir_path}/#{f_name}_medium.png`
     output = `convert #{f_path} -thumbnail 72x72\^ -gravity center -extent 72x72 #{new_dir_path}/#{f_name}_large.png`
  end
end
