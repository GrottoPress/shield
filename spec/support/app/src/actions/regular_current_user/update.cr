class RegularCurrentUser::Update < BrowserAction
  include Shield::CurrentUser::Update

  skip :pin_login_to_ip_address

  patch "/profile" do
    run_operation
  end

  def run_operation
    UpdateRegularCurrentUser.update(
      user,
      params,
      current_login: current_login
    ) do |operation, updated_user|
      if operation.saved?
        do_run_operation_succeeded(operation, updated_user)
      else
        do_run_operation_failed(operation)
      end
    end
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = user.id.to_s
    previous_def
  end
end
