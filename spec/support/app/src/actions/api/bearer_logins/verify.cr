class Api::BearerLogins::Verify < ApiAction
  include Shield::Api::BearerLogins::Verify

  skip :pin_login_to_ip_address

  post "/bearer-logins/verify" do
    run_operation
  end
end
