class Api::Users::EmailConfirmations::Destroy < ApiAction
  include Shield::Api::Users::EmailConfirmations::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/email-confirmations" do
    run_operation
  end
end
