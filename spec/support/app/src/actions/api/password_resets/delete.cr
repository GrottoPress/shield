class Api::PasswordResets::Delete < ApiAction
  include Shield::Api::PasswordResets::Delete

  skip :pin_login_to_ip_address

  delete "/password-resets/:password_reset_id/delete" do
    run_operation
  end
end
