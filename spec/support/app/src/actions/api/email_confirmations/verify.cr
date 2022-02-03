class Api::EmailConfirmations::Verify < ApiAction
  include Shield::Api::EmailConfirmations::Verify

  skip :pin_login_to_ip_address
  skip :pin_email_confirmation_to_ip_address

  post "/email-confirmations/verify" do
    run_operation
  end
end
