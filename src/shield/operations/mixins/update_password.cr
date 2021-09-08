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

    private def log_out_everywhere(user : Shield::User)
      return unless password_digest.changed?

      query = LoginQuery.new.user_id(user.id).is_active
      current_login.try { |login| query = query.id.not.eq(login.id) }
      query.update(inactive_at: Time.utc)
    end
  end
end
