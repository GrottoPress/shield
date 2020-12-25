class PasswordResets::Create < BrowserAction
  include Shield::PasswordResets::Create

  post "/password-resets" do
    run_operation
  end

  def do_run_operation_succeeded(operation, password_reset)
    response.headers["X-Password-Reset-ID"] = "pr_id"
    previous_def
  end
end
