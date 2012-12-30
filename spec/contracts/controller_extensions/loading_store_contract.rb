require "controllers_extensions/loading_store"

class DummyApplicationController
  def self.before_filter(args); end
  include ControllersExtensions::LoadingStore
end

shared_examples_for "loading store contract" do
  it "responds to current_store" do
    controller = DummyApplicationController.new

    expect do
      controller.current_store
    end.to_not raise_error NoMethodError
  end
end
