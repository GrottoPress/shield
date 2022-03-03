class Api::Users::EmailConfirmations::Delete < ApiAction
  include Shield::Api::Users::EmailConfirmations::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/email-confirmations/delete" do
    run_operation
  end
end
