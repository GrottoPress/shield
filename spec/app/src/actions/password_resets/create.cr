class PasswordResets::Create < ApiAction
  include Shield::CreatePasswordReset

  post "/password-resets" do
    start_password_reset
  end

  private def success_action(operation, password_reset)
    # flash.success = "Done! Check your email for further instructions."
    # redirect to: Logins::New
    json({a: ""})
  end

  private def failure_action(operation)
    # flash.failure = "Password reset request failed"
    # html NewPage, operation: operation
    json({a: ""})
  end
end
