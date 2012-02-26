require 'spec_helper'

describe Admin::GoodsController do

  # This should return the minimal set of attributes required to create a valid
  # Good. As you add validations to Good, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {name: "whatever"}
  end

  login_admin

  describe "GET index" do
    it "assigns all goods as @goods" do
      good = Good.create! valid_attributes
      get :index, {}
      assigns(:goods).should eq([good])
    end
  end

  describe "GET show" do
    it "assigns the requested good as @good" do
      good = Good.create! valid_attributes
      get :show, {:id => good.to_param}
      assigns(:good).should eq(good)
    end
  end

  describe "GET new" do
    it "assigns a new good as @good" do
      get :new, {}
      assigns(:good).should be_a_new(Good)
    end
  end

  describe "GET edit" do
    it "assigns the requested good as @good" do
      good = Good.create! valid_attributes
      get :edit, {:id => good.to_param}
      assigns(:good).should eq(good)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Good" do
        expect {
          post :create, {:good => valid_attributes}
        }.to change(Good, :count).by(1)
      end

      it "assigns a newly created good as @good" do
        post :create, {:good => valid_attributes}
        assigns(:good).should be_a(Good)
        assigns(:good).should be_persisted
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved good as @good" do
        # Trigger the behavior that occurs when invalid params are submitted
        Good.any_instance.stub(:save).and_return(false)
        post :create, {:good => {}}
        assigns(:good).should be_a_new(Good)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Good.any_instance.stub(:save).and_return(false)
        post :create, {:good => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested good" do
        good = Good.create! valid_attributes
        # Assuming there are no other goods in the database, this
        # specifies that the Good created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Good.any_instance.should_receive(:update_attributes).with({'name' => 'params'})
        put :update, {:id => good.to_param, :good => {'name' => 'params'}}
      end

      it "assigns the requested good as @good" do
        good = Good.create! valid_attributes
        put :update, {:id => good.to_param, :good => valid_attributes}
        assigns(:good).should eq(good)
      end

      it "redirects to the good" do
        good = Good.create! valid_attributes
        put :update, {:id => good.to_param, :good => valid_attributes}
        response.should redirect_to(admin_inventory_goods_url)
      end
    end

    describe "with invalid params" do
      it "assigns the good as @good" do
        good = Good.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Good.any_instance.stub(:save).and_return(false)
        put :update, {:id => good.to_param, :good => {}}
        assigns(:good).should eq(good)
      end

      it "re-renders the 'edit' template" do
        good = Good.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Good.any_instance.stub(:save).and_return(false)
        Good.any_instance.stub(:valid?).and_return(false)
        put :update, {:id => good.to_param, :good => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested good" do
      good = Good.create! valid_attributes
      expect {
        delete :destroy, {:id => good.to_param}
      }.to change(Good, :count).by(-1)
    end

    it "redirects to the goods list" do
      good = Good.create! valid_attributes
      delete :destroy, {:id => good.to_param}
      response.should redirect_to(admin_inventory_goods_url)
    end
  end

end
