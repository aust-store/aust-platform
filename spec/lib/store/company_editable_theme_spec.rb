require "spec_helper"

describe Store::CompanyEditableTheme do
  it_should_behave_like "a company editable theme"

  describe "#create" do
    let(:company)  { create(:barebone_company, name: "Company / \ #2") }
    let(:company2) { create(:barebone_company, name: "Company #3") }

    before do
      company2 and company
    end

    it "creates a theme for a company" do
      new_theme = Theme.create_for_company(company)
      Theme.count.should == 1
      new_theme.name.should == "#{company.name} v1"
      new_theme.path.should == "#{company.id}_company_2_v1"
      new_theme.company.should == company
      new_theme.public.should be_false

      another_new_theme = Theme.create_for_company(company)
      Theme.count.should == 2
      another_new_theme.path.should == "#{company.id}_company_2_v2"

      cloud_path = CONFIG["themes"]["paths"]["cloud"]
      theme1_path = Rails.root.join(cloud_path, "#{company.id}_company_2_v1").to_s
      theme2_path = Rails.root.join(cloud_path, "#{company.id}_company_2_v2").to_s
      exists1 = Dir.exists?(theme1_path)
      exists2 = Dir.exists?(theme2_path)
      exists1.should be_true
      exists2.should be_true
      FileUtils.remove_dir(theme1_path)
      FileUtils.remove_dir(theme2_path)
    end
  end
end
