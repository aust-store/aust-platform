require 'spec_helper'

describe CustomField do
  describe "validations" do
    describe "#name" do
      it "doesn't allow duplicated names" do
        field1 = create(:custom_field, name: "Field Whatever")
        field1.should be_valid
        field2 = build(:custom_field, name: "Field Whatever")
        field2.should_not be_valid
      end
    end
  end

  describe "callbacks" do
    describe "create_alphanumeric_name on before_save" do
      let(:field) { create(:custom_field, name: "Field Whatever") }

      it "generates an alphanumeric name" do
        field.alphanumeric_name.should == "field_whatever"
      end

      it "doesn't generate an existing alphanumeric name" do
        field.update_attributes(name: "another name")
        field2 = create(:custom_field, name: "Field Whatever")

        field.alphanumeric_name.should == "field_whatever"
        field2.alphanumeric_name.should == "field_whatever_2"
        field2.update_attributes(name: "yet another name")
        field3 = create(:custom_field, name: "Field Whatever")
        field3.alphanumeric_name.should == "field_whatever_3"
      end
    end
  end
end
