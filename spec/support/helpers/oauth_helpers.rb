module Helpers
  module OauthHelpers
    def set_oauth_header(options = {})
      access_token = create_access_token(user: options[:user])
      request.headers["Authorization"] = "Bearer " + access_token.token
    end

    def create_access_token(options = {})
      FactoryGirl.create(:access_token,
                         resource_owner_id: options[:user].id)
    end
  end
end
