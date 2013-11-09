require "spec_helper"

describe Company do
  describe "callbacks" do
    describe "sanitize_domain" do
      it "converts www.domain.com to domain.com" do
        company = FactoryGirl.build(:company, domain: "www.domain.com")
        company.valid?
        expect(company.domain).to eq "domain.com"
      end
    end

    describe "set_default_theme on creation" do
      it "sets the theme to overblue" do
        FactoryGirl.create(:theme)
        company = Company.new
        company.valid?
        expect(company.theme.name).to eq "Overblue"
      end

      it "doesn't set the theme to overblue if it already has one" do
        FactoryGirl.create(:theme)
        flat_pink = FactoryGirl.create(:theme, :flat_pink)
        company = FactoryGirl.create(:company, theme: flat_pink)
        expect(company.theme).to eq flat_pink
        company.valid?
        expect(company.theme).to eq flat_pink
      end
    end
  end

  describe "#items_on_sale_on_main_page" do
    let(:items) { double }

    it "returns items on sale the main page" do
      company = Company.new
      company.stub(:items) { items }
      items.stub(:items_on_sale) { :items }
      company.items_on_sale_on_main_page.should == :items
    end
  end

  describe "#items_on_sale_in_category" do
    let(:items) { double }

    it "returns items on sale in a category" do
      company = Company.new
      company.stub(:items) { items }
      items.stub(:items_on_sale_in_category).with(2) { :items }
      company.items_on_sale_in_category(2).should == :items
    end
  end

  describe "#zipcode" do
    it "returns the company zipcode" do
      company = Company.new
      company.stub(:settings) { double(zipcode: "123") }
      company.zipcode.should == "123"
    end
  end

  describe "#has_zipcode?" do
    it "returns true when a zipcode is present" do
      company = Company.new
      company.stub(:zipcode) { "123" }
      company.has_zipcode?.should == true
    end

    it "returns false when zipcode is empty" do
      company = Company.new
      company.stub(:zipcode) { "" }
      company.has_zipcode?.should == false
    end
  end

  describe "#contact_email" do
    it "returns the contact email" do
      company = FactoryGirl.create(:company, contact: create(:contact, email: "rock@star.com"))
      company.contact_email.should == "rock@star.com"
    end

    it "returns nil if company has no contact configured" do
      company = FactoryGirl.create(:company, contact: nil)
      company.contact_email.should be_nil
    end
  end
end
