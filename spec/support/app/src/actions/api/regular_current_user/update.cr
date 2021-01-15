class Api::RegularCurrentUser::Update < ApiAction
  include Shield::Api::CurrentUser::Update

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
end
