require 'spec_helper'

describe Admin::TaxonomiesController do
  login_admin

  it_obeys_the "admin application controller contract"

  describe "POST create" do
    it "returns the id of the newly created item" do
      post :create, name: 'Name', parent_id: '2'
      json = ActiveSupport::JSON.decode(response.body)['taxonomy']
      json['parent_id'].should == 2
      json['name'].should == 'Name'
    end
  end
end
