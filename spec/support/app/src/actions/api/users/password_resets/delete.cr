class Api::Users::PasswordResets::Delete < ApiAction
  include Shield::Api::Users::PasswordResets::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/password-resets/delete" do
    run_operation
  end
end
