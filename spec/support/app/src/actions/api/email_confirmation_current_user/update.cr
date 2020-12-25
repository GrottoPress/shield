class Api::EmailConfirmationCurrentUser::Update < ApiAction
  include Shield::Api::EmailConfirmationCurrentUser::Update

  skip :pin_login_to_ip_address

  patch "/ec/profile" do
    run_operation
  end

  def run_operation
    UpdateEmailConfirmationCurrentUser.update(
      user,
      params,
      current_login: current_login,
      remote_ip: remote_ip
    ) do |operation, updated_user|
      if operation.saved?
        do_run_operation_succeeded(operation, updated_user)
      else
        do_run_operation_failed(operation)
      end
    end
  end
end
