require File.new('./lib/photo.rb')

puts "What directory are the photos in?"
photo_dir = gets.chomp

puts "Opening directory #{photo_dir}"
Photo.from_directory(photo_dir).each do |photo|
  timestamp = photo.get_non_standard_timestamp
  photo.set_created_at(timestamp)
end
