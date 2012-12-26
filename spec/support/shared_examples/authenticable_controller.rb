shared_examples "authenticable controller" do
  describe "authenticable controller" do
    login_user nil

    it "redirects the unlogged user to the sign in page" do
      get :show
      response.should redirect_to "/users/sign_in"
    end
  end
end
