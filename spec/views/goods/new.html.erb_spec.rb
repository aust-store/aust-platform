require 'spec_helper'

describe "goods/new" do
  before(:each) do
    assign(:good, stub_model(Good,
      :store => nil,
      :name => "MyString",
      :description => "MyText",
      :reference_number => 1,
      :cost => "9.99",
      :profit => "",
      :lot => "MyString"
    ).as_new_record)
  end

  it "renders new good form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => goods_path, :method => "post" do
      assert_select "input#good_store", :name => "good[store]"
      assert_select "input#good_name", :name => "good[name]"
      assert_select "textarea#good_description", :name => "good[description]"
      assert_select "input#good_reference_number", :name => "good[reference_number]"
      assert_select "input#good_cost", :name => "good[cost]"
      assert_select "input#good_profit", :name => "good[profit]"
      assert_select "input#good_lot", :name => "good[lot]"
    end
  end
end
