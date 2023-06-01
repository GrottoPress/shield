module Shield::ValidatePassword
  # References:
  #
  # - https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  macro included
    skip_default_validations

    {% if @type < Avram::Operation %}
      before_run do
        require_lowercase
        require_uppercase
        require_number
        require_special_char
        validate_password_length
      end
    {% else %}
      before_save do
        require_lowercase
        require_uppercase
        require_number
        require_special_char
        validate_password_length
      end
    {% end %}

    private def require_lowercase
      return unless Shield.settings.password_require_lowercase

      password.value.try do |value|
        value.each_char { |char| return if char.ascii_lowercase? }
        password.add_error Rex.t(:"operation.error.password_lowercase_required")
      end
    end

    private def require_uppercase
      return unless Shield.settings.password_require_uppercase

      password.value.try do |value|
        value.each_char { |char| return if char.ascii_uppercase? }
        password.add_error Rex.t(:"operation.error.password_uppercase_required")
      end
    end

    private def require_number
      return unless Shield.settings.password_require_number

      password.value.try do |value|
        value.each_char { |char| return if char.ascii_number? }
        password.add_error Rex.t(:"operation.error.password_number_required")
      end
    end

    private def require_special_char
      return unless Shield.settings.password_require_special_char

      password.value.try do |value|
        value.each_char { |char| return unless char.ascii_alphanumeric? }

        password.add_error Rex.t(
          :"operation.error.password_special_char_required",
        )
      end
    end

    private def validate_password_length
      min = Shield.settings.password_min_length
      max = 64 # To mitigate DoS. Also cuz bcrypt has a max length

      validate_size_of password,
        min: min,
        max: max,
        allow_nil: true,
        message: Rex.t(
          :"operation.error.password_length_invalid",
          min: min,
          max: max
        )
    end
  end
end
