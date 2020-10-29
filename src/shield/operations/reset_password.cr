module Shield::ResetPassword
  macro included
    attribute password : String
    attribute password_confirmation : String

    before_save do
      validate_required password
    end

    after_save end_password_resets

    include Shield::UpdatePassword
    include Shield::DeleteSession(PasswordResetSession)

    private def set_password_digest
      password.value.try do |value|
        password_digest.value = CryptoHelper.hash_bcrypt(value)
      end
    end

    private def end_password_resets(user : User)
      PasswordResetQuery.new
        .user_id(user.id)
        .active
        .update(ended_at: Time.utc)
    end
  end
end
