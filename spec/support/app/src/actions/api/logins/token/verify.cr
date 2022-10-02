class Api::Logins::Token::Verify < ApiAction
  include Shield::Api::Logins::Token::Verify

  skip :pin_login_to_ip_address

  post "/logins/token/verify" do
    run_operation
  end
end
