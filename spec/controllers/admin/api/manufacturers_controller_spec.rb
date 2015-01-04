require 'spec_helper'

describe Admin::Api::ManufacturersController do
  login_admin

  describe "GET index" do
    it "searchs for taxonomies with a given name" do
      FactoryGirl.create(:manufacturer, name: "Honda", company: @company)
      manufacturer2 = FactoryGirl.create(:manufacturer, name: "Nike", company: @company)

      xhr :get, :index, { search: "nik" }
      ActiveSupport::JSON.decode(response.body).should == {
        "manufacturers" => [
          { "id"         => "#{manufacturer2.id}",
            "name"       => manufacturer2.name }
        ]
      }
    end
  end
end
