Photos.from_directory.each do |photo|
  timestamp = photo.get_non_standard_timestamp
  photo.set_created_at(timestamp)
end
