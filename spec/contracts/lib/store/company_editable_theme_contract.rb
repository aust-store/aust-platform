require "store/company_editable_theme"

shared_examples_for "a company editable theme" do
  subject { Store::CompanyEditableTheme.new(double) }

  it "responds to create" do
    subject.should respond_to(:create)
  end
end
