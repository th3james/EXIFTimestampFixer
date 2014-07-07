require 'exiftool'

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
    exif_data = Exiftool.new(@file.path)
    exif_data[:file_modify_date]
  end
end

describe Photo do
  describe "#from_directory" do
    context "given the test asset directory" do
      subject(:photos) { Photo.from_directory('test_assets') }

      it "returns the an array with only the photo files in that directory" do
        expect(photos.length).to eq(3)
      end

      it "returns Photo instances" do
        expect(photos[0]).to be_a(Photo)
      end
    end
  end

  describe "#new" do
    it "takes a file" do
      file = double()
      photo = Photo.new(file)
    end
  end

  describe "#file_is_a_photo?" do
    it "returns true when given a photo file" do
      result = Photo.file_is_a_photo? File.new('test_assets/fish.jpg')
      expect(result).to be(true)
    end

    it "returns false when given a non-photo file" do
      result = Photo.file_is_a_photo? File.new('test_assets/not_a_photo.txt')
      expect(result).to be(false)
    end
  end

  describe ".get_non_standard_timestamp" do

    it "returns the date modified from the non-standard field" do
      expected_date = Time.parse("2005-09-13 09:26:58 +0100")
      photo = Photo.new(File.new("test_assets/fish.jpg"))

      expect(photo.get_non_standard_timestamp).to eq(expected_date)
    end
  end
end

=begin
puts "What directory are the photos in?"
photo_dir = gets.chomp

puts "Opening directory #{photo_dir}"
Photo.from_directory(photo_dir).each do |photo|
  timestamp = photo.get_non_standard_timestamp
  photo.set_created_at(timestamp)
end
=end
