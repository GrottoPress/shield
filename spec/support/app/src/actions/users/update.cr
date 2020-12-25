class Users::Update < BrowserAction
  include Shield::Users::Update

  skip :pin_login_to_ip_address
  skip :check_authorization

  patch "/users/:user_id" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = user.id.to_s
    previous_def
  end
end
