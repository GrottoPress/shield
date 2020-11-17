module Shield::LoginPipes
  macro included
    before :disable_caching
    before :require_logged_in
    before :require_logged_out
    before :pin_login_to_ip_address

    def require_logged_in
      if logged_in?
        continue
      else
        ReturnUrlSession.new(session).set(request)
        response.status_code = 403
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
        response.status_code = 403
        do_pin_login_to_ip_address_failed
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
      flash.keep.failure = "You are not logged in"
      redirect to: CurrentLogin::New
    end

    def do_require_logged_out_failed
      flash.keep.info = "You are logged in"
      redirect_back fallback: CurrentUser::Show
    end

    def do_pin_login_to_ip_address_failed
      flash.keep.failure = "Your IP address has changed. Please log in again."
      redirect to: CurrentLogin::New
    end
  end
end
