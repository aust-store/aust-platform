require 'spec_helper'

describe "goods/index" do
  before(:each) do
    assign(:goods, [
      stub_model(Good,
        :store => nil,
        :name => "Name",
        :description => "MyText",
        :reference_number => 1,
        :cost => "9.99",
        :profit => "",
        :lot => "Lot"
      ),
      stub_model(Good,
        :store => nil,
        :name => "Name",
        :description => "MyText",
        :reference_number => 1,
        :cost => "9.99",
        :profit => "",
        :lot => "Lot"
      )
    ])
  end

  it "renders a list of goods" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Lot".to_s, :count => 2
  end
end
