require "spec_helper"

describe View::Store do
  it_should_behave_like "a store view"

  let(:theme) { double(full_path: "path/minimalism") }
  let(:company) { double(theme: theme) }

  subject { described_class.new(company: company, controller: nil) }

  describe "#theme_path" do
    it "finds what's the path of the theme" do
      subject.theme_path.should == "path/minimalism"
    end
  end
end
