require 'integration_spec_helper'

describe Admin::CustomersController, type: :controller do
  subject { Admin::CustomersController.new }

  it "should respond_to current_admin_user" do
    subject.should respond_to :current_admin_user
  end
end
