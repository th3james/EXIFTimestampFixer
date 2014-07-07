class Photo
  def self.from_directory directory_path
    []
  end
end

describe Photo, "#from_directory" do
  context "given the test asset directory" do
    subject(:photos) { Photo.from_directory('test_assets') }

    it "returns the an array of photos in the given directory" do
      expect(photos.length).to eq(3)
    end

    it "returns Photo instances" do
      expect(photos[0]).to be_a(Photo)
    end
  end
end

photo_dir = gets("What directory are the photos in?")

Photo.from_directory(photo_dir).each do |photo|
  timestamp = photo.get_non_standard_timestamp
  photo.set_created_at(timestamp)
end
