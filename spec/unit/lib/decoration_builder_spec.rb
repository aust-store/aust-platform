require "unit_spec_helper"

module Admin; class GoodDecorator < ApplicationDecorator; end; end
require "decoration_builder"

describe DecorationBuilder do
  it "returns a decorated Good" do
    good = double
    Admin::GoodDecorator.stub(:decorate)
                        .with(good) { :good }
    DecorationBuilder.good(good).should == :good
  end
end
