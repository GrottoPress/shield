module Shield::Api::EmailConfirmationPipes
  macro included
    include Shield::EmailConfirmationPipes

    def pin_email_confirmation_to_ip_address
      email_confirmation_params = EmailConfirmationParams.new(params)
      email_confirmation = email_confirmation_params.email_confirmation

      if email_confirmation.nil? ||
        !email_confirmation.not_nil!.active? ||
        email_confirmation.not_nil!.ip_address == remote_ip.try &.address
        continue
      else
        EndEmailConfirmation.update!(email_confirmation.not_nil!, session: nil)
        response.status_code = 403
        do_pin_email_confirmation_to_ip_address_failed
      end
    end

    def do_pin_email_confirmation_to_ip_address_failed
      json({
        status: "failure",
        message: "Your IP address has changed. Please try again."
      })
    end
  end
end
