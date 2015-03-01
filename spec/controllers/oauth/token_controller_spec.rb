require 'spec_helper'

describe Doorkeeper::TokensController do
  let!(:admin_user) { create(:admin_user, email: "admin@example.com", password: "1234567") }

  describe "POST create" do
    it "authenticates with grant_type 'password'" do
      post :create, { grant_type: 'password', username: "admin@example.com", password: "1234567" }

      ActiveSupport::JSON.decode(response.body).should == {
        "access_token"  => Doorkeeper::AccessToken.last.token,
        "expires_in"    => 43200,
        "refresh_token" => Doorkeeper::AccessToken.last.refresh_token,
        "token_type"    => "bearer"
      }
    end

    it "authenticates with grant_type 'refresh_token'" do
      token = create_access_token(user: admin_user)

      post :create, { grant_type: 'refresh_token', refresh_token: token.refresh_token }

      ActiveSupport::JSON.decode(response.body).should == {
        "access_token"  => Doorkeeper::AccessToken.last.token,
        "expires_in"    => 43200,
        "refresh_token" => Doorkeeper::AccessToken.last.refresh_token,
        "token_type"    => "bearer"
      }
    end
  end
end
