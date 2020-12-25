class Api::EmailConfirmations::Edit < ApiAction
  include Shield::Api::EmailConfirmations::Edit

  skip :pin_login_to_ip_address
  skip :pin_email_confirmation_to_ip_address

  get "/email-confirmations/edit" do
    run_operation
  end
end
