require "spec_helper"

describe Company do
  subject { Company.new }

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
        create(:theme)
        company = Company.new
        company.valid?
        expect(company.theme.name).to eq "Minimalism"
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

    describe "create_default_pages after_save on creation" do
      let(:company) { create(:company) }

      it "creates an About Us page on new stores" do
        company.pages.count.should == 1

        about_us_page = company.pages.first
        about_us_page.title.should == "Quem somos"
        company.save
        company.pages.count.should == 1
      end
    end
  end

  describe "validations" do
    describe "handle uniqueness" do
      it "doesn't allow companies with the same handle" do
        create(:barebone_company, handle: "handle1")
        company2 = build(:barebone_company, handle: "handle1")
        company3 = build(:barebone_company, handle: "handle2")
        expect(company2).to be_invalid
        expect(company3).to be_valid
      end
    end
  end

  describe "scopes" do
    let(:company) { create(:company) }
    before do
      create(:role, :customer)
      create(:role, :supplier)
    end

    describe ".customers" do
      it "loads only customers, not suppliers" do
        customer = create(:person, customer: true, store: company)
        create(:person, customer: false, supplier: true, store: company)
        company.customers.should == [customer]
      end
    end

    describe ".suppliers" do
      it "loads only suppliers, not customers" do
        supplier = create(:person, supplier: true, customer: false, store: company)
        create(:person, customer: true, supplier: false, store: company)
        company.suppliers.should == [supplier]
      end
    end
  end

  describe "#items_on_sale_for_website_main_page" do
    let(:items) { double(items_on_listing_for_website: :items) }

    it "returns items on sale the main page" do
      subject.stub(:items) { items }
      subject.items_on_sale_for_website_main_page.should == :items
    end
  end

  describe "#items_on_sale_in_category_for_website" do
    let(:items) { double }

    it "returns items on sale in a category" do
      items.stub(:items_on_sale_in_category_for_website).with(2) { :items }
      subject.stub(:items) { items }
      subject.items_on_sale_in_category_for_website(2).should == :items
    end
  end

  describe "#zipcode" do
    it "returns the company zipcode" do
      subject.stub(:settings) { double(zipcode: "123") }
      subject.zipcode.should == "123"
    end

    it "returns nil if no settings were set" do
      subject.stub(:settings) { nil }
      subject.zipcode.should be_nil
    end
  end

  describe "#has_zipcode?" do
    it "returns true when a zipcode is present" do
      subject.stub(:zipcode) { "123" }
      subject.has_zipcode?.should == true
    end

    it "returns false when zipcode is empty" do
      subject.stub(:zipcode) { "" }
      subject.has_zipcode?.should == false
    end
  end

  describe "#has_domain?" do
    it "returns true when a domain is present" do
      subject.domain = "petshop.com"
      subject.has_domain?.should == true
    end

    it "returns false when domain is empty" do
      subject.domain = ""
      subject.has_domain?.should == false
    end
  end

  describe "#has_payment_gateway_configured?" do
    it "returns true when a gateway is configured" do
      subject.payment_gateway = build(:payment_gateway)
      subject.has_payment_gateway_configured?.should == true
    end

    it "returns false when a gateway is configured" do
      subject.payment_gateway = nil
      subject.has_payment_gateway_configured?.should == false
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

  describe "#google_analytics_id" do
    it "returns whatever the settings return" do
      company = build(:company, settings: build(:company_setting))
      company.google_analytics_id.should == "UA-2345678-1"
    end
  end

  describe "#sales_enabled?" do
    let(:company) { build(:company, settings: settings) }

    context "sales are enabled" do
      let(:settings) { build(:company_setting, sales_enabled: "1") }

      it "returns true if sales are enabled" do
        company.sales_enabled?.should == true
      end
    end

    context "sales are disabled" do
      let(:settings) { build(:company_setting, sales_enabled: "0") }

      it "returns true if sales are enabled" do
        company.sales_enabled?.should == false
      end
    end
  end
end
