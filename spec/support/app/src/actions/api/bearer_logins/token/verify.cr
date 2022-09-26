class Api::BearerLogins::Token::Verify < ApiAction
  include Shield::Api::BearerLogins::Token::Verify

  skip :pin_login_to_ip_address

  post "/bearer-logins/token/verify" do
    run_operation
  end
end
