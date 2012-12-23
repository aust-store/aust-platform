require 'spec_helper'

describe User do
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
    end

    describe "social_security_number" do
      it { should     allow_value("141.482.543-93").for(:social_security_number) }
      it { should     allow_value("14148254393").for(:social_security_number) }
      it { should_not allow_value("111.111.111-11").for(:social_security_number) }
    end
  end
end
