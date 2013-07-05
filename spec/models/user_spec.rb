require 'spec_helper'

describe User do
  it_should_behave_like "addressable", :user

  describe "validations" do
    it "validates emails" do
      subject.should     allow_value("user@example.com").for(:email)
      subject.should_not allow_value("http://user@example.com").for(:email)
      subject.should_not allow_value("").for(:email)
    end

    describe "phone numbers" do
      describe "mobile and home numbers" do
        specify "either home or mobile number is required" do
          user = FactoryGirl.build_stubbed(:user)
          user.mobile_number = nil
          user.home_number   = nil
          expect(user).to be_invalid
        end

        specify "mobile number is not needed if home number is present" do
          user = FactoryGirl.build_stubbed(:user)
          user.mobile_number = nil
          user.home_number   = "12345678"
          expect(user).to be_valid
        end

        specify "home number is not needed if mobile is present" do
          user = FactoryGirl.build_stubbed(:user)
          user.mobile_number = "12345678"
          user.home_number   = nil
          expect(user).to be_valid
        end
      end

      describe "area codes" do
        specify "home area code is needed if home number is present" do
          user = FactoryGirl.build_stubbed(:user)
          user.home_number = "12345678"
          user.home_area_number = nil
          expect(user).to be_invalid
        end

        specify "work area code is needed if work number is present" do
          user = FactoryGirl.build_stubbed(:user)
          user.work_number = "12345678"
          user.work_area_number = nil
          expect(user).to be_invalid
        end

        specify "mobile area code is needed if mobile number is present" do
          user = FactoryGirl.build_stubbed(:user)
          user.mobile_number = "12345678"
          user.mobile_area_number = nil
          expect(user).to be_invalid
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
      # user already has 'Baker street' address
      user = FactoryGirl.create(:user)
      first_address = user.addresses.first
      expect(user.default_address).to eq(first_address)

      gotham = FactoryGirl.build(:address)
      user.addresses << gotham
      expect(user.default_address).to eq(first_address)

      gotham.update_attribute(:default, true)
      expect(first_address.reload).to_not be_default
      expect(user.default_address).to eq(gotham)

      angel_grove = FactoryGirl.build(:address, default: true)
      user.addresses << angel_grove
      expect(user.default_address).to eq(angel_grove)

      user.addresses.reload
      user.addresses.one? { |a| a.default == true }.should be_true
    end
  end

  describe "#first_phone_number" do
    it "returns the home area and number if available" do
      user = FactoryGirl.build(:user)
      user.first_phone_number.should == { area: "53", phone: "11111111" }
    end

    it "returns the mobile area and number if available and home's not available" do
      user = FactoryGirl.build(:user)
      user.home_number = nil
      user.first_phone_number.should == { area: "54", phone: "22222222" }
    end

    it "returns the mobile area and number if available and home's not available" do
      user = FactoryGirl.build(:user)
      user.home_number = nil
      user.mobile_number = nil
      user.first_phone_number.should == { area: "55", phone: "33333333" }
    end
  end
end
