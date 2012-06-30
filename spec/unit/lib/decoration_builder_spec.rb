class DecorationBuilder; end
module Admin; class GoodDecorator; end; end

require "decoration_builder"

describe DecorationBuilder do
  it "returns a decorated Good" do
    good = double
    Admin::GoodDecorator.stub(:decorate)
                        .with(good) { :good }
    DecorationBuilder.good(good).should == :good
  end
end
