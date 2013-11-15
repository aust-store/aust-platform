require "view/mustache_template_controller_dictionary"

describe View::MustacheTemplateControllerDictionary do
  let(:controller) { double(params: params) }

  subject { described_class.new(controller) }

  describe "#template_for_controller" do
    context "store/home/index" do
      let(:params) { {controller: "store/home", action: "index"} }
      its(:template_for_controller) { should == "home" }
    end

    context "store/products/show" do
      let(:params) { {controller: "store/products", action: "show"} }
      its(:template_for_controller) { should == "product" }
    end
  end
end
