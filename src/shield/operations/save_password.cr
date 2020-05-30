module Shield::SavePassword
  macro included
    attribute password : String
    attribute password_confirmation : String

    before_save do
      validate_password
      validate_size_of password,
        min: Shield.settings.password_min_length,
        allow_nil: true
      validate_confirmation_of password, with: password_confirmation

      set_password_hash
    end

    after_commit notify_password_change

    private def validate_password
      require_lowercase
      require_uppercase
      require_number
    end

    private def set_password_hash
      password.value.try do |value|
        password_hash.value = Login.hash(value).to_s unless value.empty?
      end
    end

    private def notify_password_change(user : User)
      return unless Shield.settings.password_notify_change

      if user.updated_at > user.created_at && password_hash.changed?
        mail PasswordChangeNotificationEmail, user
      end
    end

    private def require_lowercase
      password.value.try do |value|
        return unless Shield.settings.password_require_lowercase

        unless value =~ /^.*[a-z].*$/
          password.add_error("must contain a lowercase letter")
        end
      end
    end

    private def require_uppercase
      password.value.try do |value|
        return unless Shield.settings.password_require_uppercase

        unless value =~ /^.*[A-Z].*$/
          password.add_error("must contain an uppercase letter")
        end
      end
    end

    private def require_number
      password.value.try do |value|
        return unless Shield.settings.password_require_number

        unless value =~ /^.*[0-9].*$/
          password.add_error("must contain a number")
        end
      end
    end
  end
end
