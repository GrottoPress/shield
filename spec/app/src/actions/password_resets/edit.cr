class PasswordResets::Edit < ApiAction
  include Shield::EditPasswordReset

  get "/password-resets/edit" do
    verify_password_reset
  end

  private def success_action(password_reset)
    json({status: 0})
  end

  private def failure_action
    json({status: 1})
  end
end
