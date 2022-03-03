class Api::EmailConfirmations::Destroy < ApiAction
  include Shield::Api::EmailConfirmations::Destroy

  skip :pin_login_to_ip_address

  delete "/email-confirmations/:email_confirmation_id" do
    run_operation
  end
end
