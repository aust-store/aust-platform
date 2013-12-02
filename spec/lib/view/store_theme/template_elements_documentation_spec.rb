require "spec_helper"

describe View::StoreTheme::TemplateElementsDocumentation do
  class DummyDoc
    extend View::StoreTheme::TemplateElementsDocumentation
  end

  describe ".desc" do
    context "normal methods" do
      it "adds a method to the documentation" do
        DummyDoc.desc(:company_name)

        method = DummyDoc.documentation["nome_da_empresa"]
        method.command.should == "{{{nome_da_empresa}}}"
        method.original_name.should == :company_name
      end
    end

    context "block methods" do
      it "adds a method to the documentation" do
        DummyDoc.desc(:company_name, block: true)

        method = DummyDoc.documentation["nome_da_empresa"]
        method.command.should == "{{#nome_da_empresa}} HTML {{/nome_da_empresa}}"
        method.original_name.should == :company_name
      end
    end
  end
end
