class Api::Users::PasswordResets::Destroy < ApiAction
  include Shield::Api::Users::PasswordResets::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/password-resets" do
    run_operation
  end
end
