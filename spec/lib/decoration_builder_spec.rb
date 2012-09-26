require "decoration_builder"

describe DecorationBuilder do
  before do
    stub_const("Admin::GoodDecorator", Object.new)
  end

  describe ".good" do
    it "returns a decorated Good" do
      good = double
      Admin::GoodDecorator.stub(:decorate)
                          .with(good) { :good }
      DecorationBuilder.good(good).should == :good
    end
  end
end
