class PasswordResets::Create < BrowserAction
  include Shield::PasswordResets::Create

  post "/password-resets" do
    run_operation
  end

  def do_run_operation_succeeded(operation, password_reset)
    response.headers["X-Password-Reset-ID"] = "pr_id"
    previous_def
  end

  private def success_action(operation)
    response.headers["X-Password-Reset-Status"] = "success"
    previous_def
  end
end
