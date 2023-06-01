module Shield::ValidateLogin
  macro included
    skip_default_validations

    before_save do
      validate_email_required
      validate_ip_address_required
      validate_password_required
      validate_email_valid
      validate_token_digest_required
    end

    include Lucille::ValidateStatus

    private def validate_email_required
      validate_required email,
        message: Rex.t(:"operation.error.email_required")
    end

    private def validate_ip_address_required
      validate_required ip_address,
        message: Rex.t(:"operation.error.ip_address_required")
    end

    private def validate_password_required
      validate_required password,
        message: Rex.t(:"operation.error.password_required")
    end

    private def validate_email_valid
      validate_email email, message: Rex.t(
        :"operation.error.email_invalid",
        email: email.value
      )
    end

    private def validate_token_digest_required
      validate_required token_digest,
        message: Rex.t(:"operation.error.token_required")
    end
  end
end
