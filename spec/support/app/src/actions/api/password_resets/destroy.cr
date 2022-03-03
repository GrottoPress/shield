class Api::PasswordResets::Destroy < ApiAction
  include Shield::Api::PasswordResets::Destroy

  skip :pin_login_to_ip_address

  delete "/password-resets/:password_reset_id" do
    run_operation
  end
end
