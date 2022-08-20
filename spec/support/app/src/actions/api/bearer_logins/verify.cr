class Api::BearerLogins::Verify < ApiAction
  include Shield::Api::BearerLogins::Verify

  post "/bearer-logins/verify" do
    run_operation
  end
end
