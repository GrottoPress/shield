# Implements Bearer authentication as defined
# in [RFC 6750](https://tools.ietf.org/html/rfc6750)
module Shield::Api::AuthenticationPipes
  macro included
    include Shield::AuthenticationPipes

    def require_logged_in
      if logged_in? || bearer_logged_in?
        continue
      else
        ReturnUrlSession.new(session).set(request)
        send_invalid_token_response
        do_require_logged_in_failed
      end
    end

    def require_logged_out
      if logged_out? && bearer_logged_out?
        continue
      else
        do_require_logged_out_failed
      end
    end

    def pin_login_to_ip_address
      if logged_out? ||
        current_login!.ip_address == remote_ip.try &.address
        continue
      else
        LogUserOut.update!(current_login!)
        response.status_code = 403
        do_pin_login_to_ip_address_failed
      end
    end

    def pin_password_reset_to_ip_address
      password_reset = PasswordResetParams.new(params).password_reset

      if password_reset.nil? ||
        !password_reset.not_nil!.active? ||
        password_reset.not_nil!.ip_address == remote_ip.try &.address
        continue
      else
        EndPasswordReset.update!(password_reset.not_nil!)
        response.status_code = 403
        do_pin_password_reset_to_ip_address_failed
      end
    end

    def pin_email_confirmation_to_ip_address
      email_confirmation_params = EmailConfirmationParams.new(params)
      email_confirmation = email_confirmation_params.email_confirmation

      if email_confirmation.nil? ||
        !email_confirmation.not_nil!.active? ||
        email_confirmation.not_nil!.ip_address == remote_ip.try &.address
        continue
      else
        EndEmailConfirmation.update!(email_confirmation.not_nil!)
        response.status_code = 403
        do_pin_email_confirmation_to_ip_address_failed
      end
    end

    def do_require_logged_in_failed
      json({status: "failure", message: "You are not logged in"})
    end

    def do_require_logged_out_failed
      json({status: "failure", message: "You are already logged in"})
    end

    def do_pin_login_to_ip_address_failed
      json({
        status: "failure",
        message: "Your IP address has changed. Please log in again."
      })
    end

    def do_pin_password_reset_to_ip_address_failed
      json({
        status: "failure",
        message: "Your IP address has changed. Please try again."
      })
    end

    def do_pin_email_confirmation_to_ip_address_failed
      json({
        status: "failure",
        message: "Your IP address has changed. Please try again."
      })
    end

    private def send_invalid_token_response
      response.status_code = 401
      response.headers["WWW-Authenticate"] =
        %(Bearer error="invalid_token", scope="#{bearer_login_scope}")
    end

    private def bearer_login_scope
      BearerLoginHelper.scope(self.class)
    end
  end
end
