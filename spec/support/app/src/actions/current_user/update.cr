class CurrentUser::Update < BrowserAction
  include Shield::CurrentUser::Update

  skip :pin_login_to_ip_address

  patch "/profile" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = user.id.to_s
    previous_def
  end
end
