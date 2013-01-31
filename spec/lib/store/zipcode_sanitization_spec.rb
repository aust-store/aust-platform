require "store/zipcode_sanitization"

describe Store::ZipcodeSanitization do

  describe "#sanitize_zipcode" do
    it "returns 9630000 for 963d0000 string" do
      expect(Store::ZipcodeSanitization.sanitize_zipcode("96360-000")).to eq(96360000)
    end

    it "returns 96360000 for 96360,000 string" do
      expect(Store::ZipcodeSanitization.sanitize_zipcode("96360,000")).to eq(96360000)
    end

    it "returns 96360000 for 96360.000 string" do
      expect(Store::ZipcodeSanitization.sanitize_zipcode("96360.000")).to eq(96360000)
    end
  end
end