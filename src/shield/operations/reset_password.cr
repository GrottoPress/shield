module Shield::ResetPassword
  macro included
    attribute password : String

    before_save do
      validate_required password
    end

    after_completed end_password_resets

    include Shield::UpdatePassword
    include Shield::DeleteSession

    private def set_password_digest
      password.value.try do |value|
        password_digest.value = CryptoHelper.hash_bcrypt(value)
      end
    end

    private def end_password_resets(user : User)
      PasswordResetQuery.new
        .user_id(user.id)
        .is_active
        .update(ended_at: Time.utc)
    end

    private def delete_session(user : User)
      session.try { |session| PasswordResetSession.new(session).delete }
    end
  end
end
