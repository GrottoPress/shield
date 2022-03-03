class Api::EmailConfirmations::Delete < ApiAction
  include Shield::Api::EmailConfirmations::Delete

  skip :pin_login_to_ip_address

  delete "/email-confirmations/:email_confirmation_id/delete" do
    run_operation
  end
end
