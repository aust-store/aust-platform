require "spec_helper"

describe ThemeDocumentation do
  subject { described_class.new }

  before do
    View::StoreTheme::TemplateElements.new(double.as_null_object)
  end

  describe "#has_command?" do
    it "return true for existing command" do
      subject.has_command?(:nome_da_empresa).should be_true
    end

    it "return false for inexisting command" do
      subject.has_command?(:harharhar).should be_false
    end
  end

  describe "#original_method_name" do
    describe "#nome_da_empresa" do
      it "returns company_name" do
        subject.original_method_name(:nome_da_empresa).should == :company_name
      end
    end
  end

  describe "#mustache_documentation" do
    it "returns all described methods" do
      subject.mustache_documentation.keys.should == [
        "nome_da_empresa"
      ]
    end

    specify "no description should be empty" do
      values = subject.mustache_documentation.values

      values.map(&:description).none? { |v| v.blank? }
      values.map(&:original_name).none? { |v| v.blank? }
    end
  end
end
