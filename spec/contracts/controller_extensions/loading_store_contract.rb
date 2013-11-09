require "controllers_extensions/loading_store"

class DummyApplicationController
  def self.before_filter(args); end
  include ControllersExtensions::LoadingStore

  def request; nil; end
end

shared_examples_for "loading store contract" do
  before do
    stub_const("Rails", double.as_null_object)
    stub_const("RailsRequest", double.as_null_object)
    stub_const("Company", double.as_null_object)
    stub_const("Store::CompanyDecorator", double.as_null_object)
  end

  it "responds to current_store" do
    controller = DummyApplicationController.new

    expect do
      controller.current_store
    end.to_not raise_error
  end
end
