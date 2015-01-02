FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    resource_owner_id 1
    application_id 1
    token "36e1df6ee9dd7f9080a3214bf1989b602b8c13680255ba017da870e9e6571dd4"
    refresh_token "def931d93ffc852d3c9969a351fa82e2f9864a911bf3796c6a12e8c405afded1"
    expires_in 14400

    trait :limitless do
      expires_in nil
    end

    trait :expired do
      expires_in(-100)
    end
  end
end
