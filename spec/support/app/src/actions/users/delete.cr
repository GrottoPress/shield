class Users::Delete < BrowserAction
  include Shield::Users::Delete

  skip :pin_login_to_ip_address
  skip :check_authorization

  delete "/users/:user_id" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = "user_id"
    previous_def
  end
end
