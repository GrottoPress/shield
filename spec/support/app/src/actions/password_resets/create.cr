class PasswordResets::Create < BrowserAction
  include Shield::PasswordResets::Create

  post "/password-resets" do
    run_operation
  end

  def do_run_operation_succeeded(operation, password_reset)
    json({exit: 0})
  end

  def do_run_operation_failed(operation)
    json({exit: 1})
  end
end
