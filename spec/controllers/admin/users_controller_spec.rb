require "spec_helper"

describe Admin::UsersController do
  login_admin

  describe "POST create" do
    it "creates an user" do
      user = double
      controller.current_company.stub(:admin_users) { user }
      user.should_receive(:new)
        .with("name" => "1",
              "role" => "collaborator")
        .and_return(double(save: nil))
      post :create, admin_user: { name: 1 }
    end

    it "instantiates a user variable" do
      user = double(save: nil)
      AdminUser.stub(:new) { user }
      post :create, admin_user: { name: 1 }
      assigns(:user).should == user
    end

    describe "response" do
      it "redirects to the users index" do
        AdminUser.stub(:new) { double(save: true) }
        post :create, admin_user: { name: 1 }
        response.should redirect_to admin_users_url
      end

      it "renders the form again" do
        AdminUser.stub(:new) { double(save: false) }
        controller.stub(:authorize!)
        post :create, admin_user: { name: 1 }
        response.should render_template "new"
      end
    end
  end

  context "Existing users management" do
    before do
      @user = double
      controller.current_company.stub(:admin_users) { @user }
      @user.stub(:find).with("1").and_return(@user)
      controller.stub(:sign_in)
      controller.stub(:authorize!)
    end

    describe "PUT update" do
      context "successfully updating the user" do
        before do
          @user.should_receive(:update_attributes) { true }
        end

        it "updates the chosen user" do
          put :update, id: 1, admin_user: { name: "name" }
          response.should redirect_to admin_users_url
        end

        it "force sign the chosen user again" do
          controller.should_receive(:sign_in).with(@user, bypass: true)
          put :update, id: 1, admin_user: { name: "name" }
        end
      end

      context "failing to update the user" do
        it "renders the form again" do
          @user.should_receive(:update_attributes) { false }
          put :update, id: 1, admin_user: { name: "name" }
          response.should render_template "edit"
        end
      end
    end

    describe "DELETE destroy" do
      it "deletes the chosen user" do
        @user.should_receive(:destroy) { true }
        delete :destroy, id: 1
        response.should redirect_to admin_users_url
      end

      it "redirects when deleting fails" do
        @user.stub(:destroy) { false }
        delete :destroy, id: 1
        flash[:notice].should_not be_nil
        response.should redirect_to admin_users_url
      end
    end
  end
end
