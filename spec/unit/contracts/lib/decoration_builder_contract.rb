module Admin; class GoodDecorator < ApplicationDecorator; end; end
require "decoration_builder"

shared_examples_for "Decoration Builder contract" do
  it "returns responds to good" do
    Admin::GoodDecorator.stub(:decorate)
    expect do
      DecorationBuilder.good(double)
    end.to_not raise_error
  end
end
