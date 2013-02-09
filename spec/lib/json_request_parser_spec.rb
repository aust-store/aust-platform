require "json_request_parser"

describe JsonRequestParser do
  let(:json_with_nested_objects) { {"order" => { "items" => { "price" => 123 } }} }

  describe "#add_attributes_suffix" do
    it "adds _attributes to nested objects so Rails is pleased" do
      params = described_class.new(json_with_nested_objects).add_attributes_suffix
      params.should == { "order" => { "items_attributes" => { "price" => 123 } } }
    end
  end
end
