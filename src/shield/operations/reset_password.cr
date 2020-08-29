module Shield::ResetPassword
  macro included
    include Shield::UpdatePassword

    attribute password : String
    attribute password_confirmation : String

    needs session : Lucky::Session

    before_save do
      validate_required password
    end

    after_save end_password_resets

    after_commit delete_session

    private def set_password_digest
      password.value.try do |value|
        password_digest.value = CryptoHelper.hash_bcrypt(value)
      end
    end

    private def end_password_resets(user : User)
      PasswordResetQuery.new
        .user_id(user.id)
        .status(PasswordReset::Status.new :started)
        .update(ended_at: Time.utc, status: PasswordReset::Status.new(:ended))
    end

    private def delete_session(user : User)
      PasswordResetSession.new(session).delete
    end
  end
end
