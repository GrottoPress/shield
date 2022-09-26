class Api::EmailConfirmations::Token::Verify < ApiAction
  include Shield::Api::EmailConfirmations::Token::Verify

  skip :pin_login_to_ip_address
  skip :pin_email_confirmation_to_ip_address

  post "/email-confirmations/token/verify" do
    run_operation
  end
end
