require 'mini_exiftool'

class Photo
  SUPPORTED_TYPES = ['image/jpeg; charset=binary']

  def initialize file
    @file = file
  end

  def self.from_directory directory_path
    photos = []
    Dir.foreach(directory_path) do |file_name|
      file = File.new(
        File.join(directory_path, file_name)
      )

      if Photo.file_is_a_photo? file
        photos << Photo.new(file)
      end
    end

    return photos
  end

  def self.file_is_a_photo? file
    mimetype = `file -Ib "#{file.path}"`.gsub(/\n/,"")

    SUPPORTED_TYPES.include? mimetype
  end

  def get_non_standard_timestamp
    exif_photo = MiniExiftool.new(@file.path)
    exif_photo.filemodifydate
  end

  def set_created_at(timestamp)
    exif_photo = MiniExiftool.new(@file.path)
    exif_photo.date_time_original = timestamp
    exif_photo.create_date = timestamp
    exif_photo.save
  end

  def path
    @file.path
  end

end
