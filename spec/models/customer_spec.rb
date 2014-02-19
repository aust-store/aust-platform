require 'spec_helper'

describe Customer do
  it_should_behave_like "addressable", :customer
  it_should_behave_like "uuid", :customer, :uuid

  describe "has_password" do
    it "is set to true by default" do
      create(:customer).has_password.should === true
    end

    context "when customer is created in the point of sale" do
      it "is set to false when no password is given" do
        create(:customer, :pos).has_password.should === false
      end

      it "is set to true when a password is given" do
        create(:customer, :pos, password: "123456", password_confirmation: "123456").has_password.should === true
      end
    end
  end

  describe "validations" do
    describe "point of sale specifics" do
      it "is valid with specific fields for point of sale" do
        customer = Customer.new(first_name: "John",
                                last_name: "Rambo",
                                store: build(:company),
                                social_security_number: "141.482.543-93",
                                environment: "point_of_sale")
        customer.should be_valid
      end
    end

    describe "environments" do
      it "accepts admin" do
        build(:customer, environment: "admin").should be_valid
      end

      it "accepts website" do
        build(:customer, environment: "website").should be_valid
      end

      it "accepts point_of_sale" do
        build(:customer, environment: "point_of_sale").should be_valid
        build(:customer, :pos).should be_valid
      end

      it "doesn't accept offline" do
        build(:customer, environment: "offline").should_not be_valid
      end
    end

    it "validates emails" do
      subject.should     allow_value("user@example.com").for(:email)
      subject.should_not allow_value("http://user@example.com").for(:email)
      customer = build(:customer, email: "")
      customer.should_not be_valid
    end

    describe "password" do
      context "website" do
        it "is required on creation" do
          build(:customer).should be_valid
          build(:customer, password: nil).should_not be_valid
          build(:customer, password_confirmation: nil).should_not be_valid
        end
      end

      context "point of sale" do
        it "is not required" do
          build(:customer, :pos).should be_valid
          build(:customer, :pos, password: nil).should be_valid
          build(:customer, :pos, password_confirmation: nil).should be_valid
        end
      end
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
      it "validates 14148254393" do
        build(:customer, social_security_number: "14148254393").should be_valid
      end

      it "validates 141.482.543-93" do
        build(:customer, social_security_number: "141.482.543-93").should be_valid
      end

      it "does not allow 111.111.111-11 to be valid" do
        customer = build(:customer, social_security_number: "111.111.111-11")
        customer.should_not be_valid
      end

      it "allows any number in the development environment" do
        Rails.env.stub(:development?) { true }
        build(:customer, social_security_number: "1").should be_valid
        build(:customer, social_security_number: "").should_not be_valid
        build(:customer, social_security_number: nil).should_not be_valid
      end
    end
  end

  describe "callbacks" do
    describe "#sanitize_social_security_number" do
      it "removes all dots and dashes from the number" do
        create(:customer).social_security_number.should == "14148254393"
      end
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

  describe "#enabled" do
    it "enables the customer" do
      customer = create(:customer, enabled: false)
      expect(customer).to_not be_enabled
      customer.enable
      expect(customer).to be_enabled
    end
  end

  describe "#disable" do
    it "disables the customer" do
      customer = create(:customer)
      expect(customer).to be_enabled
      customer.disable
      expect(customer).to_not be_enabled
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
