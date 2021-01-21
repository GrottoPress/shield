module Shield::UpdatePassword
  macro included
    needs current_login : Login?

    before_save do
      set_password_digest
    end

    after_save log_out_everywhere

    include Shield::ValidatePassword

    private def set_password_digest
      password.value.try do |value|
        bcrypt = BcryptHash.new(value)
        return if bcrypt.verify?(password_digest.original_value.to_s)
        password_digest.value = bcrypt.hash
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
