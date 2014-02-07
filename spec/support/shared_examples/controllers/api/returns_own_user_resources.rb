shared_examples_for "an api endpoint returning only own user resources" do |root_name, factory_name|
  describe "GET index" do
    before do
      # TODO fix this crap
      company_key = (build(factory_name).respond_to?(:company)) ? :company : :store

      @resource1 = create(factory_name,
                          company_key => @company,
                          admin_user: @admin_user)
      @resource2 = create(factory_name,
                          company_key => @company,
                          admin_user: create(:admin_user, company: @company))
    end

    it "returns only the user's own resources" do
      xhr :get, :index

      json = ActiveSupport::JSON.decode(response.body)
      json[root_name.to_s].all? do |resource|
        resource["id"].should == @resource1.uuid
      end.should be_true
    end
  end
end
