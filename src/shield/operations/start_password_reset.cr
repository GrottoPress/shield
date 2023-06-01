module Shield::StartPasswordReset
  macro included
    getter? guest_email = false

    attribute email : String

    include Shield::SetIpAddressFromRemoteAddress
    include Lucille::Activate
    include Shield::SetToken

    before_save do
      set_inactive_at
      set_success
      set_user_id
    end

    after_commit send_email

    include Shield::ValidatePasswordReset

    before_save do
      send_guest_email
    end

    private def set_inactive_at
      active_at.value.try do |value|
        inactive_at.value = value + Shield.settings.password_reset_expiry
      end
    end

    private def set_success
      success.value = false
    end

    private def set_user_id
      email.value.try do |value|
        user_id.value = UserQuery.new
          .email.lower.eq(value.downcase)
          .first?
          .try(&.id)
      end
    end

    private def send_guest_email
      return unless guest_email?
      GuestPasswordResetRequestEmail.new(self).deliver_later
    end

    private def send_email(password_reset : Shield::PasswordReset)
      password_reset = PasswordResetQuery.preload_user(password_reset)
      PasswordResetRequestEmail.new(self, password_reset).deliver_later
    end
  end
end
