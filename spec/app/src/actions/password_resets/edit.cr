class PasswordResets::Edit < ApiAction
  include Shield::PasswordResets::Edit

  get "/password-resets/edit" do
    run_operation
  end

  def do_run_operation_succeeded(operation, password_reset)
    json({status: 0})
  end

  def do_run_operation_failed(operation)
    json({status: 1})
  end
end
