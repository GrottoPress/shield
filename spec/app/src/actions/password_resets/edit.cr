class PasswordResets::Edit < ApiAction
  include Shield::PasswordResets::Edit

  get "/password-resets/edit" do
    verify_password_reset
  end

  private def success_action(operation, password_reset)
    json({status: 0})
  end

  def failure_action(operation)
    json({status: 1})
  end
end
