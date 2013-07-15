require 'spec_helper'

describe Store::ContactController do
  before do
    controller.stub(:current_store) { double(contact_email: :email).as_null_object }
  end

  describe "GET 'new'" do
    it "returns http success" do
      ContactForm.stub(:new) { :contact }
      get 'new'
      assigns(:contact).should == :contact
    end
  end

  describe "GET 'create'" do
    it "redirects to success page if contact was made" do
      ContactForm.stub(:new).with("name" => "Zod", "to" => :email) { double(deliver: true) }
      get 'create', contact_form: {name: "Zod"}
      response.should redirect_to success_contact_url
    end

    it "renders the new view to show errors" do
      ContactForm.stub(:new) { double(deliver: false) }
      get 'create', contact_form: {}
      response.should render_template :new
    end
  end
end
