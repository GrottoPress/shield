module Shield::StartEmailConfirmation # EmailConfirmation::SaveOperation
  macro included
    permit_columns :email

    include Shield::SetIpAddressFromRemoteAddress
    include Lucille::Activate
    include Shield::SetToken

    before_save do
      set_inactive_at
      set_success
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

    private def set_success
      success.value = false
    end

    private def send_user_email
      return unless user_email?
      UserEmailConfirmationRequestEmail.new(self).deliver_later
    end

    private def send_email(email_confirmation : Shield::EmailConfirmation)
      EmailConfirmationRequestEmail.new(self, email_confirmation).deliver_later
    end
  end
end
