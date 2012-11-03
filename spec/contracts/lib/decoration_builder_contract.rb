require "decoration_builder"

shared_examples "Decoration Builder contract" do
  describe "DecorationBuilder" do
    it "responds to good" do
      expect do
        DecorationBuilder.good(double)
      end.to_not raise_error NoMethodError
    end

    it "responds to inventory_entries" do
      expect do
        DecorationBuilder.inventory_entries(double)
      end.to_not raise_error NoMethodError
    end
  end
end
