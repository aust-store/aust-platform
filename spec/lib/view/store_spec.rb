require "spec_helper"

describe View::Store do
  it_should_behave_like "a store view"

  let(:theme) { double(path: "minimalism") }
  let(:company) { double(theme: theme) }

  subject { described_class.new(company: company, controller: nil) }

  describe "#theme_path" do
    let(:theme_path) { Rails.root.join(CONFIG["themes"]["paths"]["checked_out"]) }
    let(:theme_name) { "minimalism" }

    it "finds what's the path of the theme" do
      subject.theme_path.should == "#{theme_path.to_s}/#{theme_name}"
    end
  end
end
