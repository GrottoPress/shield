module Shield::StartPasswordReset
  macro included
    getter? guest_email = false

    attribute email : String

    before_save do
      validate_required email
      validate_email email

      set_user_id
      set_guest_email

      validate_email_exists

      send_guest_email
    end

    after_commit send_email

    include Shield::RequireIpAddress
    include Shield::StartAuthentication

    private def set_inactive_at
      inactive_at.value = active_at.value! +
        Shield.settings.password_reset_expiry
    end

    private def set_user_id
      email.value.try do |value|
        user_id.value = UserQuery.new.email(value.downcase).first?.try(&.id)
      end
    end

    private def set_guest_email
      email.value.try do |value|
        @guest_email = user_id.value.nil? && value.email?
      end
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
