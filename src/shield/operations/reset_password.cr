module Shield::ResetPassword
  macro included
    attribute password : String

    before_save do
      validate_password_required
    end

    after_save end_password_resets

    include Shield::UpdatePassword
    include Shield::DeleteSession

    private def validate_password_required
      validate_required password,
        message: Rex.t(:"operation.error.password_required")
    end

    private def end_password_resets(user : Shield::User)
      PasswordResetQuery.new
        .user_id(user.id)
        .is_active
        .update(inactive_at: Time.utc)
    end

    private def delete_session(user : Shield::User)
      session.try { |session| PasswordResetSession.new(session).delete }
    end
  end
end
