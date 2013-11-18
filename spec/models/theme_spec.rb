require 'spec_helper'

describe Theme do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :path }
    it { should validate_uniqueness_of :path }
  end

  describe "#create_for_company" do
    let(:company) { create(:barebone_company, name: "Company / \ #2") }
    let(:company2) { create(:barebone_company, name: "Company #3") }

    before do
      company2 and company
    end

    it "creates a theme for a company" do
      new_theme = Theme.create_for_company(company)
      Theme.count.should == 1
      new_theme.name.should == "#{company.name}"
      new_theme.path.should == "#{company.id}_company_2_v1"
      new_theme.company.should == company
      new_theme.public.should be_false

      another_new_theme = Theme.create_for_company(company)
      Theme.count.should == 2
      another_new_theme.path.should == "#{company.id}_company_2_v2"
    end
  end
end
