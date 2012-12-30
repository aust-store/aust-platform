require "controllers_extensions/admin_application"

class DummyAdminController
  include ControllersExtensions::AdminApplication
end

shared_examples_for "admin application controller contract" do
  it "responds to current_user" do
    controller = DummyAdminController.new
    controller.stub(:current_admin_user)

    expect do
      controller.current_user
    end.to_not raise_error
  end
end
