require "spec_helper"

describe View::StoreTheme::TemplateElements do
  let(:company) { double(name: "My company") }
  let(:view) { double(company: company).as_null_object }

  subject { described_class.new(view) }

  describe "#respond_to?" do
    it "responds to company_name" do
      subject.respond_to?(:company_name).should be_true
    end

    it "responds to the translated name of company_name" do
      subject.respond_to?(:nome_da_empresa).should be_true
    end
  end

  describe "#company_name" do
    it "returns My company" do
      subject.company_name.should == "My company"
    end
  end

  describe "#nome_da_empresa" do
    it "returns My company too" do
      subject.nome_da_empresa.should == "My company"
    end
  end
end
