module Shield::AuthenticationPipes
  macro included
    def require_logged_in
      if logged_in?
        continue
      else
        ReturnUrlSession.new(session).set(request)
        do_require_logged_in_failed
      end
    end

    def require_logged_out
      if logged_out?
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
        LogUserOut.update!(current_login!, session: session)
        do_pin_login_to_ip_address_failed
      end
    end

    def pin_password_reset_to_ip_address
      password_reset = PasswordResetSession.new(session).password_reset

      if password_reset.nil? ||
        !password_reset.not_nil!.status.started? ||
        password_reset.not_nil!.ip_address == remote_ip.try &.address
        continue
      else
        EndPasswordReset.update!(password_reset.not_nil!, session: session)
        do_pin_password_reset_to_ip_address_failed
      end
    end

    def pin_email_confirmation_to_ip_address
      email_confirmation_session = EmailConfirmationSession.new(session)
      email_confirmation = email_confirmation_session.email_confirmation

      if email_confirmation.nil? ||
        email_confirmation.not_nil!.ip_address == remote_ip.try &.address
        continue
      else
        email_confirmation_session.delete
        do_pin_email_confirmation_to_ip_address_failed
      end
    end

    def set_no_referrer_policy
      response.headers["Referrer-Policy"] = "no-referrer"
      continue
    end

    def disable_caching
      response.headers["Cache-Control"] = "no-store"
      response.headers["Expires"] = "Sun, 16 Aug 1987 07:00:00 GMT"
      continue
    end

    def do_require_logged_in_failed
      flash.keep
      flash.failure = "You are not logged in"
      redirect to: Logins::New
    end

    def do_require_logged_out_failed
      flash.keep
      flash.info = "You are already logged in"
      redirect_back fallback: CurrentUser::Show
    end

    def do_pin_login_to_ip_address_failed
      flash.keep
      flash.failure = "Your IP address has changed. Please log in again."
      redirect to: Logins::New
    end

    def do_pin_password_reset_to_ip_address_failed
      flash.keep
      flash.failure = "Your IP address has changed. Please try again."
      redirect to: PasswordResets::New
    end

    def do_pin_email_confirmation_to_ip_address_failed
      flash.keep
      flash.failure = "Your IP address has changed. Please try again."
      redirect to: EmailConfirmations::New
    end
  end
end
