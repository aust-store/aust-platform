require 'spec_helper'

describe Admin::Api::TaxonomiesController do
  login_admin

  describe "GET index" do
    it "searchs for taxonomies with a given name" do
      FactoryGirl.create(:taxonomy, name: "Sadmen", store: @company)
      taxonomy2 = FactoryGirl.create(:taxonomy, name: "Madmen", store: @company)

      xhr :get, :index, { search: "mad" }
      ActiveSupport::JSON.decode(response.body).should == {
        "taxonomies" => [
          { "id"         => "#{taxonomy2.id}",
            "name"       => taxonomy2.name,
            "parent_id"  => nil }
        ]
      }
    end
  end
end
