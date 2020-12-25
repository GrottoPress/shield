class Users::Create < BrowserAction
  include Shield::Users::Create

  skip :pin_login_to_ip_address
  skip :check_authorization

  post "/users" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = "user_id"
    previous_def
  end
end
