require 'spec_helper'

describe Address do
  describe "validations" do
    it { should     allow_value("RS").for(:state) }
    it { should_not allow_value("Rio Grande do Sul").for(:state) }
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

  describe "#copied" do
    it "returns a hash with all attributes except Rails defaults" do
      address = FactoryGirl.build_stubbed(:address)
      address.copied.should == {
        "address_1"    => "Baker street",
        "address_2"    => "Obviously not 221A",
        "city"         => "London",
        "zipcode"      => "96360000",
        "state"        => "RS",
        "country"      => "BR",
        "neighborhood" => "Center",
        "number"       => "221B"
      }
    end
  end
end
