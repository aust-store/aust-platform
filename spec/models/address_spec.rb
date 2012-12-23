require 'spec_helper'

describe Address do
  describe "validations" do
    it { should     allow_value("96360-000").for(:zipcode) }
    it { should     allow_value("96360000").for(:zipcode) }
    it { should_not allow_value("9636000").for(:zipcode) }
  end

  describe "callbacks" do
    describe "before_filter" do
      it "sets the country as Brazil" do
        address = FactoryGirl.build_stubbed(:address, country: "US")
        address.valid?
        expect(address.country).to eq("BR")
      end
    end
  end
end
