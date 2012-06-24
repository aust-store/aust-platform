require "controllers/admin/application_controller"

shared_examples_for "application controller contract" do
  subject { Admin::ApplicationController.new }

  it "responds to current_user" do
    subject.stub(:current_admin_user)
    expect do
      subject.current_user
    end.to_not raise_error
  end

end
