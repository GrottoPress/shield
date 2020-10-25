module Shield::StartEmailConfirmation
  macro included
    permit_columns :email

    before_save do
      send_user_email
    end

    after_commit send_email

    include Shield::SaveEmail
    include Shield::RequireIpAddress
    include Shield::StartAuthentication

    private def set_ended_at
      ended_at.value = started_at.value.not_nil! +
        Shield.settings.email_confirmation_expiry
    end

    private def send_user_email
      return unless user_email?
      mail_later UserEmailConfirmationRequestEmail, self
    end

    private def send_email(email_confirmation : EmailConfirmation)
      mail_later EmailConfirmationRequestEmail, self, email_confirmation
    end
  end
end
