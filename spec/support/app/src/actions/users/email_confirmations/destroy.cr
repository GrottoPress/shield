class Users::EmailConfirmations::Destroy < BrowserAction
  include Shield::Users::EmailConfirmations::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/email-confirmations" do
    run_operation
  end

  def do_run_operation_succeeded(operation, email_confirmation)
    response.headers["X-End-Email-Confirmations"] = "true"
    previous_def
  end
end
