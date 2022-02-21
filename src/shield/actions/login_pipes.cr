module Shield::LoginPipes
  macro included
    before :disable_caching
    before :require_logged_in
    before :require_logged_out
    before :pin_login_to_ip_address
    before :enforce_login_idle_timeout
    before :check_authorization

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
        current_login.ip_address == remote_ip?.try &.address
        continue
      else
        EndCurrentLogin.update!(current_login, session: session)
        response.status_code = 403
        do_pin_login_to_ip_address_failed
      end
    end

    def enforce_login_idle_timeout
      timeout_session = LoginIdleTimeoutSession.new(session)

      if logged_out?
        timeout_session.delete
        continue
      elsif timeout_session.expired?
        EndCurrentLogin.update!(current_login, session: session)
        response.status_code = 403
        do_enforce_login_idle_timeout_failed
      else
        timeout_session.set
        continue
      end
    end

    def check_authorization
      if logged_out? || authorize?(current_user)
        continue
      else
        response.status_code = 403
        do_check_authorization_failed
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
      flash.failure = Rex.t(:"action.pipe.not_logged_in")
      redirect to: CurrentLogin::New
    end

    def do_require_logged_out_failed
      flash.info = Rex.t(:"action.pipe.not_logged_out")
      redirect_back fallback: CurrentUser::Show
    end

    def do_pin_login_to_ip_address_failed
      flash.failure = Rex.t(:"action.pipe.ip_address_changed")
      redirect to: CurrentLogin::New
    end

    def do_enforce_login_idle_timeout_failed
      flash.failure = Rex.t(:"action.pipe.login_timed_out")
      redirect to: CurrentLogin::New
    end

    def do_check_authorization_failed
      flash.failure = Rex.t(:"action.pipe.authorization_failed")
      redirect_back fallback: CurrentUser::Show
    end

    def authorize?(user : Shield::User) : Bool
      false
    end
  end
end
