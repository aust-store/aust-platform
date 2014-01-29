require "store/policy/commerce_setup"

describe Store::Policy::CommerceSetup do
  let(:company)      { double }

  subject { described_class.new(company) }

  describe "#missing_taxonomy?" do
    it "returns true when missing taxonomy" do
      company.stub(:taxonomies) { [] }
      expect(subject.missing_taxonomy?).to be_true
    end

    it "returns false when not missing taxonomy" do
      company.stub(:taxonomies) { [1] }
      expect(subject.missing_taxonomy?).to be_false
    end
  end

  describe "#missing_products?" do
    it "returns true when company has items on sale" do
      company.stub(:items_on_sale_for_website_main_page) { [] }
      expect(subject.missing_products?).to be_true
    end

    it "returns false when company has no items on sale" do
      company.stub(:items_on_sale_for_website_main_page) { [1] }
      expect(subject.missing_products?).to be_false
    end
  end

  describe "#missing_zipcode?" do
    it "returns true when zipcode is present" do
      company.stub(:has_zipcode?) { false }
      expect(subject.missing_zipcode?).to be_true
    end

    it "returns false when company has no zipcode" do
      company.stub(:has_zipcode?) { true }
      expect(subject.missing_zipcode?).to be_false
    end
  end

  describe "#missing_domain?" do
    it "returns true when domain is present" do
      company.stub(:has_domain?) { false }
      expect(subject.missing_domain?).to be_true
    end

    it "returns false when company has no domain" do
      company.stub(:has_domain?) { true }
      expect(subject.missing_domain?).to be_false
    end
  end

  describe "#missing_payments?" do
    it "returns true when payment methods are is present" do
      company.stub(:has_payment_gateway_configured?) { false }
      expect(subject.missing_payments?).to be_true
    end

    it "returns false when company has no payment methods" do
      company.stub(:has_payment_gateway_configured?) { true }
      expect(subject.missing_payments?).to be_false
    end
  end

  describe "#missing_analytics?" do
    before do
      stub_const("View::GoogleAnalytics", Class.new)
    end

    it "returns true when analytics are present" do
      View::GoogleAnalytics.stub_chain(:new, :enabled?) { true }
      expect(subject.missing_analytics?).to be_false
    end

    it "returns false when analytics are installed" do
      View::GoogleAnalytics.stub_chain(:new, :enabled?) { false }
      expect(subject.missing_analytics?).to be_true
    end
  end
end
