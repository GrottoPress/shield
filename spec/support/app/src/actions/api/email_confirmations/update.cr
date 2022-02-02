class Api::EmailConfirmations::Update < ApiAction
  include Shield::Api::EmailConfirmations::Update

  skip :pin_login_to_ip_address
  skip :pin_email_confirmation_to_ip_address

  patch "/email-confirmations" do
    run_operation
  end
end
