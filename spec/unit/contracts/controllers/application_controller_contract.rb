require "controllers/admin/application_controller"

class Admin::ApplicationController
  def current_admin_user; end
end

shared_examples_for "application controller contract" do
  subject { Admin::ApplicationController.new }

  it "responds to current_user" do
    expect do
      subject.current_user
    end.to_not raise_error
  end

end
