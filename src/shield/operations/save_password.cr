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
      require_special_char
    end

    private def set_password_hash
      password.value.try do |value|
        password_hash.value = Login.hash(value).to_s unless value.empty?
      end
    end

    private def notify_password_change(user : User)
      return unless Shield.settings.password_notify_change

      unless password_hash.changed?(from: nil)
        mail PasswordChangeNotificationEmail, self, user
      end
    end

    private def require_lowercase
      return unless Shield.settings.password_require_lowercase

      password.value.try do |value|
        value.each_char { |char| return if char.ascii_lowercase? }
        password.add_error("must contain a lowercase letter")
      end
    end

    private def require_uppercase
      return unless Shield.settings.password_require_uppercase

      password.value.try do |value|
        value.each_char { |char| return if char.ascii_uppercase? }
        password.add_error("must contain an uppercase letter")
      end
    end

    private def require_number
      return unless Shield.settings.password_require_number

      password.value.try do |value|
        value.each_char { |char| return if char.ascii_number? }
        password.add_error("must contain a number")
      end
    end

    private def require_special_char
      return unless Shield.settings.password_require_special_char

      password.value.try do |value|
        value.each_char { |char| return unless char.ascii_alphanumeric? }
        password.add_error("must contain a special character")
      end
    end
  end
end
