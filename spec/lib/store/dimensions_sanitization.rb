require "store/dimensions_sanitization"

describe Store::DimensionsSanitization do

  describe "#sanitize" do
    it "returns 12.1 for 12,1 string" do
      expect(Store::DimensionsSanitization.sanitize("12,1")).to eq(12.1)
    end

    it "returns 12.12 for 12,12 string" do
      expect(Store::DimensionsSanitization.sanitize("12,12")).to eq(12.12)
    end

    it "returns 12.0 for 12 string" do
      expect(Store::DimensionsSanitization.sanitize("12")).to eq(12.0)
    end

    it "returns 120710.0 for 120o710cm string" do
      expect(Store::DimensionsSanitization.sanitize("120o710cm")).to eq(120710.0)
    end

    it "returns a string without letters" do
      expect(Store::DimensionsSanitization.sanitize("120abc.a0a0a")).to eq(120.0)
    end

    context "decimals" do
      it "returns 120000.0 for 120.000.00 string" do
        expect(Store::DimensionsSanitization.sanitize("120.000.00")).to eq(120000.0)
      end

      it "returns 120000.0 for 120,000,00 string" do
        expect(Store::DimensionsSanitization.sanitize("120,000,00")).to eq(120000.0)
      end

      it "returns 120000.0 for 120.000.0 string" do
        expect(Store::DimensionsSanitization.sanitize("120.000.0")).to eq(120000.0)
      end

      it "returns 12000.0 for 120.00.0 string" do
        expect(Store::DimensionsSanitization.sanitize("120.00.0")).to eq(12000.0)
      end

      it "returns 120000.0 for 120,000,0 string" do
        expect(Store::DimensionsSanitization.sanitize("120,000,0")).to eq(120000.0)
      end

      it "returns 120000.0 for 120.000,0 string" do
        expect(Store::DimensionsSanitization.sanitize("120.000,0")).to eq(120000.0)
      end

      it "returns 120000.123 for 120,000.123cm string" do
        expect(Store::DimensionsSanitization.sanitize("120,000.123cm")).to eq(120000.123)
      end

      it "returns 120000.123 for 120,000.123cm string" do
        expect(Store::DimensionsSanitization.sanitize("120,000.123cm")).to eq(120000.123)
      end

      it "returns 120000.123 for 120,000.123cm string" do
        expect(Store::DimensionsSanitization.sanitize("120.000.12345cm")).to eq(120000.12345)
      end
    end

    context "thousands" do
      it "returns 10000.0 for 10.000 string" do
        expect(Store::DimensionsSanitization.sanitize("10.000")).to eq(10000.0)
      end

      it "returns 10200.0 for 10,200 string" do
        expect(Store::DimensionsSanitization.sanitize("10.200")).to eq(10200.0)
      end

      it "returns 120000.123 for 120.000.123cm string" do
        expect(Store::DimensionsSanitization.sanitize("120.000.123cm")).to eq(120000.123)
      end
    end
  end
end