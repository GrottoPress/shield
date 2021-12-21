module Shield::StartEmailConfirmation
  macro included
    permit_columns :email

    include Shield::SetIpAddressFromRemoteAddress
    include Shield::StartAuthentication

    before_save do
      set_inactive_at
    end

    after_commit send_email

    include Shield::ValidateEmailConfirmation

    before_save do
      send_user_email
    end

    private def set_inactive_at
      active_at.value.try do |value|
        inactive_at.value = value + Shield.settings.email_confirmation_expiry
      end
    end

    private def send_user_email
      return unless user_email?
      mail_later UserEmailConfirmationRequestEmail, self
    end

    private def send_email(email_confirmation : Shield::EmailConfirmation)
      mail_later EmailConfirmationRequestEmail, self, email_confirmation
    end
  end
end
