require 'spec_helper'

describe Customer do
  it_should_behave_like "addressable", :customer

  describe "validations" do
    it "validates emails" do
      subject.should     allow_value("user@example.com").for(:email)
      subject.should_not allow_value("http://user@example.com").for(:email)
      subject.should_not allow_value("").for(:email)
    end

    describe "phone numbers" do
      describe "mobile and home numbers" do
        specify "either home or mobile number is required" do
          customer = FactoryGirl.build_stubbed(:customer)
          customer.mobile_number = nil
          customer.home_number   = nil
          expect(customer).to be_invalid
        end

        specify "mobile number is not needed if home number is present" do
          customer = FactoryGirl.build_stubbed(:customer)
          customer.mobile_number = nil
          customer.home_number   = "12345678"
          expect(customer).to be_valid
        end

        specify "home number is not needed if mobile is present" do
          customer = FactoryGirl.build_stubbed(:customer)
          customer.mobile_number = "12345678"
          customer.home_number   = nil
          expect(customer).to be_valid
        end
      end

      describe "area codes" do
        specify "home area code is needed if home number is present" do
          customer = FactoryGirl.build_stubbed(:customer)
          customer.home_number = "12345678"
          customer.home_area_number = nil
          expect(customer).to be_invalid
        end

        specify "work area code is needed if work number is present" do
          customer = FactoryGirl.build_stubbed(:customer)
          customer.work_number = "12345678"
          customer.work_area_number = nil
          expect(customer).to be_invalid
        end

        specify "mobile area code is needed if mobile number is present" do
          customer = FactoryGirl.build_stubbed(:customer)
          customer.mobile_number = "12345678"
          customer.mobile_area_number = nil
          expect(customer).to be_invalid
        end
      end
    end

    describe "social_security_number" do
      it { should     allow_value("141.482.543-93").for(:social_security_number) }
      it { should     allow_value("14148254393").for(:social_security_number) }
      it { should_not allow_value("111.111.111-11").for(:social_security_number) }
    end
  end

  describe "#default_address" do
    it "returns the default address" do
      # customer already has 'Baker street' address
      customer = FactoryGirl.create(:customer)
      first_address = customer.addresses.first
      expect(customer.default_address).to eq(first_address)

      gotham = FactoryGirl.build(:address)
      customer.addresses << gotham
      expect(customer.default_address).to eq(first_address)

      gotham.update_attribute(:default, true)
      expect(first_address.reload).to_not be_default
      expect(customer.default_address).to eq(gotham)

      angel_grove = FactoryGirl.build(:address, default: true)
      customer.addresses << angel_grove
      expect(customer.default_address).to eq(angel_grove)

      customer.addresses.reload
      customer.addresses.one? { |a| a.default == true }.should be_true
    end
  end

  describe "#first_phone_number" do
    it "returns the home area and number if available" do
      customer = FactoryGirl.build(:customer)
      customer.first_phone_number.should == { area: "53", phone: "11111111" }
    end

    it "returns the mobile area and number if available and home's not available" do
      customer = FactoryGirl.build(:customer)
      customer.home_number = nil
      customer.first_phone_number.should == { area: "54", phone: "22222222" }
    end

    it "returns the mobile area and number if available and home's not available" do
      customer = FactoryGirl.build(:customer)
      customer.home_number = nil
      customer.mobile_number = nil
      customer.first_phone_number.should == { area: "55", phone: "33333333" }
    end
  end
end
