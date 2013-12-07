require "view/store"

shared_examples_for "a store view" do
  subject { View::Store.new({}) }

  it "responds to theme" do
    subject.should respond_to(:theme)
  end

  it "responds to theme_path" do
    subject.should respond_to(:theme_path)
  end

  it "responds to theme_name" do
    subject.should respond_to(:theme_name)
  end

  it "responds to company" do
    subject.should respond_to(:company)
  end

  it "responds to pages" do
    subject.should respond_to(:pages)
  end

  it "responds to taxonomies" do
    subject.should respond_to(:taxonomies)
  end

  it "responds to products" do
    subject.should respond_to(:products)
  end

  it "responds to product" do
    subject.should respond_to(:product)
  end

  it "responds to banners" do
    subject.should respond_to(:banners)
  end

  it "responds to contact_email?" do
    subject.should respond_to(:contact_email?)
  end
end
