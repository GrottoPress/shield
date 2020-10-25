module Shield::StartPasswordReset
  macro included
    getter? guest_email = false

    attribute email : String

    before_save do
      validate_required email

      set_user_id
      set_guest_email

      validate_email_exists

      send_guest_email
    end

    after_commit send_email

    include Shield::ValidateEmail
    include Shield::RequireIpAddress
    include Shield::StartAuthentication

    private def set_ended_at
      ended_at.value = started_at.value.not_nil! +
        Shield.settings.password_reset_expiry
    end

    private def set_user_id
      email.value.try do |value|
        user_id.value = UserHelper.user_from_email(value).try(&.id)
      end
    end

    private def set_guest_email
      @guest_email = user_id.value.nil? && email.valid?
    end

    private def validate_email_exists
      email.add_error("does not exist") if guest_email?
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
