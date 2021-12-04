module Shield::StartPasswordReset
  macro included
    getter? guest_email = false

    attribute email : String

    before_save do
      validate_email_required
      validate_email_valid

      set_user_id
      set_guest_email

      validate_email_exists

      send_guest_email
    end

    after_commit send_email

    include Shield::RequireIpAddress
    include Shield::StartAuthentication

    private def validate_email_required
      validate_required email,
        message: Rex.t(:"operation.error.email_required")
    end

    private def validate_email_valid
      validate_email email, message: Rex.t(
        :"operation.error.email_invalid",
        email.value
      )
    end

    private def set_default_inactive_at
      active_at.value.try do |value|
        inactive_at.value = value + Shield.settings.password_reset_expiry
      end
    end

    private def set_user_id
      email.value.try do |value|
        user_id.value = UserQuery.new.email(value).first?.try(&.id)
      end
    end

    private def set_guest_email
      email.value.try do |value|
        @guest_email = user_id.value.nil? && value.email?
      end
    end

    private def validate_email_exists
      return unless guest_email?

      email.add_error Rex.t(
        :"operation.error.email_not_found",
        email: email.value
      )
    end

    private def send_guest_email
      return unless guest_email?
      mail_later GuestPasswordResetRequestEmail, self
    end

    private def send_email(password_reset : Shield::PasswordReset)
      password_reset = PasswordResetQuery.preload_user(password_reset)
      mail_later PasswordResetRequestEmail, self, password_reset
    end
  end
end
