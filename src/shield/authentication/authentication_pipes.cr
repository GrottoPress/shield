module Shield::AuthenticationPipes
  macro included
    private def require_logged_in
      if logged_in?
        continue
      else
        require_logged_in_action
      end
    end

    private def require_logged_out
      if logged_out?
        continue
      else
        require_logged_out_action
      end
    end

    private def set_no_referrer_policy
      response.headers["Referrer-Policy"] = "no-referrer"
      continue
    end

    private def disable_caching
      response.headers["Cache-Control"] = "no-store"
      response.headers["Expires"] = Time::UNIX_EPOCH.to_s
      continue
    end

    private def remember_login
      if Login.from_session(session).try &.expired?
        Login.delete_cookie(cookies)
      else
        Login.set_session(session, cookies)
      end

      continue
    end

    private def require_logged_in_action
      flash.failure = "You are not logged in"
      redirect to: Logins::New
    end

    private def require_logged_out_action
      flash.info = "You are already logged in"
      redirect_back fallback: CurrentUser::Show
    end
  end
end
