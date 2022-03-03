class Users::PasswordResets::Delete < BrowserAction
  include Shield::Users::PasswordResets::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/password-resets/delete" do
    run_operation
  end

  def do_run_operation_succeeded(operation, password_reset)
    response.headers["X-End-Password-Resets"] = "true"
    previous_def
  end
end
