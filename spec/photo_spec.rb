require 'photo'

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
      Photo.new(file)
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

  describe ".set_created_at" do
    it "sets the standard EXIF date fields to the given time" do
      exif_data = double()
      MiniExiftool.stub(:new).and_return(exif_data)

      time_stamp = Time.now

      expect(exif_data).to receive(:date_time_original=).with(time_stamp)
      expect(exif_data).to receive(:create_date=).with(time_stamp)
      expect(exif_data).to receive(:save)

      filename = 'test_assets/fish.jpg'
      photo = Photo.new(File.new(filename))

      photo.set_created_at(time_stamp)
    end
  end

  describe ".path" do
    it "returns the file path" do
      file = double()
      the_path = "hat.jpg"
      expect(file).to receive(:path).and_return(the_path)

      expect(Photo.new(file).path).to eq(the_path)
    end
  end
end
