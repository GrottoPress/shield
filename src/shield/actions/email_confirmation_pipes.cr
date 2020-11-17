module Shield::EmailConfirmationPipes
  macro included
    def pin_email_confirmation_to_ip_address
      email_confirmation_session = EmailConfirmationSession.new(session)
      email_confirmation = email_confirmation_session.email_confirmation

      if email_confirmation.nil? ||
        !email_confirmation.not_nil!.active? ||
        email_confirmation.not_nil!.ip_address == remote_ip.try &.address
        continue
      else
        EndEmailConfirmation.update!(
          email_confirmation.not_nil!,
          session: session
        )

        response.status_code = 403
        do_pin_email_confirmation_to_ip_address_failed
      end
    end

    def do_pin_email_confirmation_to_ip_address_failed
      flash.keep.failure = "Your IP address has changed. Please try again."
      redirect to: EmailConfirmations::New
    end
  end
end
