module Shield::ValidatePasswordReset
  macro included
    getter? guest_email = false

    before_save do
      set_guest_email

      validate_email_required
      validate_ip_address_required
      validate_email_valid
      validate_email_exists
    end

    include Shield::ValidateAuthenticationColumns

    private def validate_email_required
      validate_required email,
        message: Rex.t(:"operation.error.email_required")
    end

    private def validate_ip_address_required
      validate_required ip_address,
        message: Rex.t(:"operation.error.ip_address_required")
    end

    private def validate_email_valid
      validate_email email, message: Rex.t(
        :"operation.error.email_invalid",
        email: email.value
      )
    end

    private def validate_email_exists
      email.value.try do |value|
        return unless guest_email?
        email.add_error Rex.t(:"operation.error.email_not_found", email: value)
      end
    end

    private def set_guest_email
      email.value.try do |value|
        @guest_email = user_id.value.nil? && value.email?
      end
    end
  end
end
