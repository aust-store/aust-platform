shared_examples "loading taxonomy" do
  let(:store) { double.as_null_object }

  before do
    controller.stub(:current_store) { store }
  end

  describe "loading the store taxonomy" do
    describe "GET show" do
      it "should have the @taxonomy variable assigned" do
        store.stub_chain(:taxonomies, :hash_tree_for_homepage) { :taxonomy }
        get :show, id: 1
        assigns(:taxonomies).should == :taxonomy
      end
    end
  end
end
