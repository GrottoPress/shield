class PasswordResets::Destroy < BrowserAction
  include Shield::PasswordResets::Destroy

  skip :pin_login_to_ip_address

  delete "/password-resets/:password_reset_id" do
    run_operation
  end

  def do_run_operation_succeeded(operation, password_reset)
    response.headers["X-Password-Reset-ID"] = password_reset.id.to_s
    previous_def
  end
end
