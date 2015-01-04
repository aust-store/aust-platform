require "spec_helper"

describe Admin::UsersController do
  login_admin

  let(:user) { double(id: 1, save: nil) }

  describe "POST create" do
    it "creates an user" do
      controller.current_company.stub(:admin_users) { user }
      user
        .should_receive(:new)
        .with("name" => "1", "role" => "collaborator")
        .and_return(user)
      post :create, admin_user: { name: 1, role: "collaborator" }
    end

    it "doesn't allow founders to be created" do
      controller.current_company.stub(:admin_users) { user }
      user
        .should_receive(:new)
        .with("name" => "1", "role" => "collaborator")
        .and_return(user)
      post :create, admin_user: { name: 1, role: "founder" }
    end
  end

  context "Existing users management" do
    before do
      controller.current_company.stub(:admin_users) { user }
      controller.current_user.stub(:id) { user.id }
      user.stub(:find).with("1").and_return(user)
      controller.stub(:sign_in)
      controller.stub(:authorize!)
    end

    describe "PUT update" do
      context "successfully updating the user" do
        context "user being edited is himself" do
          before do
            user.should_receive(:update_attributes) { true }
          end

          it "updates the chosen user" do
            put :update, id: 1, admin_user: { name: "name" }
            response.should redirect_to admin_users_url
          end

          it "force sign the chosen user again" do
            controller.should_receive(:sign_in).with(user, bypass: true)
            put :update, id: 1, admin_user: { name: "name" }
          end
        end

        context "user is editing someone else" do
          let(:another_user) { double(id: 2, name: "another name") }

          before do
            another_user.should_receive(:update_attributes) { true }
            user.stub(:find).with("2").and_return(another_user)
          end

          it "force sign the chosen user again" do
            controller.should_not_receive(:sign_in)
            put :update, id: 2, admin_user: { name: "name" }
          end
        end
      end

      context "failing to update the user" do
        it "renders the form again" do
          user.should_receive(:update_attributes) { false }
          put :update, id: 1, admin_user: { name: "name" }
          response.should render_template "edit"
        end
      end
    end

    describe "DELETE destroy" do
      it "deletes the chosen user" do
        user.should_receive(:destroy) { true }
        delete :destroy, id: 1
        response.should redirect_to admin_users_url
      end

      it "redirects when deleting fails" do
        user.stub(:destroy) { false }
        delete :destroy, id: 1
        flash[:notice].should_not be_nil
        response.should redirect_to admin_users_url
      end
    end
  end
end
