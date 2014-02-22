require 'spec_helper'

describe Person do
  it_should_behave_like "addressable", :person
  it_should_behave_like "uuid", :person, :uuid

  describe "has_password" do
    it "is set to true by default" do
      create(:person).has_password.should === true
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
        person = Person.new(first_name: "John",
                            last_name: "Rambo",
                            store: build(:company),
                            social_security_number: "141.482.543-93",
                            environment: "point_of_sale")
        person.should be_valid
      end
    end

    describe "environments" do
      it "accepts admin" do
        build(:person, environment: "admin").should be_valid
      end

      it "accepts website" do
        build(:person, environment: "website").should be_valid
      end

      it "accepts point_of_sale" do
        build(:person, environment: "point_of_sale").should be_valid
        build(:person, :pos).should be_valid
      end

      it "doesn't accept offline" do
        build(:person, environment: "offline").should_not be_valid
      end
    end

    it "validates emails" do
      subject.should     allow_value("user@example.com").for(:email)
      subject.should_not allow_value("http://user@example.com").for(:email)
      person = build(:person, email: "")
      person.should_not be_valid
    end

    describe "password" do
      context "website" do
        it "is required on creation" do
          build(:person).should be_valid
          build(:person, password: nil).should_not be_valid
          build(:person, password_confirmation: nil).should_not be_valid
        end
      end

      context "point of sale" do
        it "is not required" do
          build(:person, :pos).should be_valid
          build(:person, :pos, password: nil).should be_valid
          build(:person, :pos, password_confirmation: nil).should be_valid
        end
      end
    end

    describe "phone numbers" do
      describe "mobile and home numbers" do
        specify "either home or mobile number is required" do
          person = FactoryGirl.build_stubbed(:person)
          person.mobile_number = nil
          person.home_number   = nil
          expect(person).to be_invalid
        end

        specify "mobile number is not needed if home number is present" do
          person = FactoryGirl.build_stubbed(:person)
          person.mobile_number = nil
          person.home_number   = "12345678"
          expect(person).to be_valid
        end

        specify "home number is not needed if mobile is present" do
          person = FactoryGirl.build_stubbed(:person)
          person.mobile_number = "12345678"
          person.home_number   = nil
          expect(person).to be_valid
        end
      end

      describe "area codes" do
        specify "home area code is needed if home number is present" do
          person = FactoryGirl.build_stubbed(:person)
          person.home_number = "12345678"
          person.home_area_number = nil
          expect(person).to be_invalid
        end

        specify "work area code is needed if work number is present" do
          person = FactoryGirl.build_stubbed(:person)
          person.work_number = "12345678"
          person.work_area_number = nil
          expect(person).to be_invalid
        end

        specify "mobile area code is needed if mobile number is present" do
          person = FactoryGirl.build_stubbed(:person)
          person.mobile_number = "12345678"
          person.mobile_area_number = nil
          expect(person).to be_invalid
        end
      end
    end

    describe "social_security_number" do
      it "validates 14148254393" do
        build(:person, social_security_number: "14148254393").should be_valid
      end

      it "validates 141.482.543-93" do
        build(:person, social_security_number: "141.482.543-93").should be_valid
      end

      it "does not allow 111.111.111-11 to be valid" do
        person = build(:person, social_security_number: "111.111.111-11")
        person.should_not be_valid
      end

      it "allows any number in the development environment" do
        Rails.env.stub(:development?) { true }
        build(:person, social_security_number: "1").should be_valid
        build(:person, social_security_number: "").should_not be_valid
        build(:person, social_security_number: nil).should_not be_valid
      end
    end

    describe "creation in the admin panel" do
      it "allows the name the be the only field filled" do
        person = Person.new(first_name: "The Tick", environment: "admin", store: build(:company))
        person.should be_valid
      end
    end
  end

  describe "callbacks" do
    describe "#sanitize_social_security_number" do
      it "removes all dots and dashes from the number" do
        create(:person).social_security_number.should == "14148254393"
      end
    end
  end

  describe "#customer?" do
    it "returns true if person is a customer" do
      subject.roles << build(:role, :customer)
      subject.should be_customer
    end

    it "returns false if person is not a customer" do
      subject.should_not be_customer
    end
  end

  describe "#supplier?" do
    it "returns true if person is a supplier" do
      subject.roles << build(:role, :supplier)
      subject.should be_supplier
    end

    it "returns false if person is not a supplier" do
      subject.should_not be_supplier
    end
  end

  describe "#default_address" do
    it "returns the default address" do
      # person already has 'Baker street' address
      person = FactoryGirl.create(:person)
      first_address = person.addresses.first
      expect(person.default_address).to eq(first_address)

      gotham = FactoryGirl.build(:address)
      person.addresses << gotham
      expect(person.default_address).to eq(first_address)

      gotham.update_attribute(:default, true)
      expect(first_address.reload).to_not be_default
      expect(person.default_address).to eq(gotham)

      angel_grove = FactoryGirl.build(:address, default: true)
      person.addresses << angel_grove
      expect(person.default_address).to eq(angel_grove)

      person.addresses.reload
      person.addresses.one? { |a| a.default == true }.should be_true
    end
  end

  describe "#enabled" do
    it "enables the person" do
      person = create(:person, enabled: false)
      expect(person).to_not be_enabled
      person.enable
      expect(person).to be_enabled
    end
  end

  describe "#disable" do
    it "disables the person" do
      person = create(:person)
      expect(person).to be_enabled
      person.disable
      expect(person).to_not be_enabled
    end
  end

  describe "#first_phone_number" do
    it "returns the home area and number if available" do
      person = FactoryGirl.build(:person)
      person.first_phone_number.should == { area: "53", phone: "11111111" }
    end

    it "returns the mobile area and number if available and home's not available" do
      person = FactoryGirl.build(:person)
      person.home_number = nil
      person.first_phone_number.should == { area: "54", phone: "22222222" }
    end

    it "returns the mobile area and number if available and home's not available" do
      person = FactoryGirl.build(:person)
      person.home_number = nil
      person.mobile_number = nil
      person.first_phone_number.should == { area: "55", phone: "33333333" }
    end
  end

  describe "#minimal_validation?" do
    it "returns true if #save_with_minimal_validation" do
      subject.stub(:update_attributes)
      subject.save_with_minimal_validation
      subject.minimal_validation?.should == true
    end

    it "returns true if #update_attributes_with_minimal_validation" do
      subject.stub(:update_attributes)
      subject.update_attributes_with_minimal_validation
      subject.minimal_validation?.should == true
    end

    it "is not minimal validation by default" do
      subject.minimal_validation?.should == false
    end
  end
end
