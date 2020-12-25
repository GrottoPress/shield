module Shield::UpdatePassword
  macro included
    needs current_login : Login? = nil

    before_save do
      set_password_digest
    end

    after_completed log_out_everywhere

    include Shield::ValidatePassword

    private def set_password_digest
      password.value.try do |value|
        return if CryptoHelper.verify_bcrypt?(
          value,
          password_digest.original_value.to_s
        )

        password_digest.value = CryptoHelper.hash_bcrypt(value)
      end
    end

    private def log_out_everywhere(user : User)
      return unless password_digest.changed?

      LoginQuery.new
        .user_id(user.id)
        .id.not.eq(current_login.try(&.id) || 0_i64)
        .is_active
        .update(ended_at: Time.utc)
    end
  end
end
