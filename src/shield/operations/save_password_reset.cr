module Shield::SavePasswordReset
  macro included
    getter token = ""
    getter? guest_email = false

    attribute user_email : String

    before_save do
      downcase_user_email

      validate_user_email
      validate_required user_email

      set_user_id
      set_guest_email
      set_token

      send_guest_email
    end

    after_commit send_email

    private def downcase_user_email
      user_email.value.try { |value| user_email.value = value.downcase }
    end

    private def validate_user_email
      user_email.value.try do |value|
        user_email.add_error("format invalid") unless value.email?
      end
    end

    private def set_user_id
      user_email.value.try do |value|
        user_id.value = User.from_email(value).try(&.id)
      end
    end

    private def set_guest_email
      @guest_email = user_id.value.nil? && user_email.valid?
    end

    private def set_token
      @token = Login.generate_token
      token_hash.value = Login.hash(@token).to_s
    end

    private def send_guest_email
      return unless guest_email?
      mail_later GuestPasswordResetRequestEmail, self
    end

    private def send_email(password_reset : PasswordReset)
      mail_later PasswordResetRequestEmail, self, password_reset
    end
  end
end
