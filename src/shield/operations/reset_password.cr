module Shield::ResetPassword
  macro included
    needs current_login : Login?

    attribute password : String

    before_save do
      validate_password_required
    end

    after_save update_password
    after_save end_password_resets

    include Shield::EndPasswordReset
    include Shield::ValidatePassword

    private def validate_password_required
      validate_required password,
        message: Rex.t(:"operation.error.password_required")
    end

    private def update_password(password_reset : Shield::PasswordReset)
      password.value.try do |value|
        UpdatePassword.update!(
          password_reset.user!,
          current_login: current_login,
          password: value
        )
      end
    end

    private def end_password_resets(password_reset : Shield::PasswordReset)
      PasswordResetQuery.new
        .user_id(password_reset.user_id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
