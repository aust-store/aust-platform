module Store; module ModelsExtensions; module Good; end; end; end;
require "models/good"

shared_examples_for "Good model contract" do
  subject { Good }

  it "responds to search_for" do
    subject.stub_chain(:search, :results)
    expect do
      subject.search_for("name", 1, page: 1, per_page: 10)
    end.to_not raise_error
  end

  it "responds to within_company" do
    expect do
      subject.within_company(123)
    end.to_not raise_error
  end

  it "responds to find" do
    expect do
      subject.find(123)
    end.to_not raise_error
  end

  it "responds to new" do
    expect do
      subject.new
    end.to_not raise_error
  end
end
