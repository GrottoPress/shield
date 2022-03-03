class Users::Logins::Destroy < BrowserAction
  include Shield::Users::Logins::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/logins" do
    run_operation
  end

  def do_run_operation_succeeded(operation, login)
    response.headers["X-Log-Out-Everywhere"] = "true"
    previous_def
  end
end
