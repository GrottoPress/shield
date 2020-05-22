module Shield::AuthenticationPipes
  macro included
    private def require_logged_in
      if logged_in?
        continue
      else
        flash.failure = "You are not logged in"
        Login.set_return_path(session, request.resource)
        redirect to: Logins::New
      end
    end

    private def require_logged_out
      if logged_out?
        continue
      else
        flash.info = "You are already logged in"
        redirect to: Home::Index # TODO: Redirect to previous page?
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
      Login.set_session(session, cookies)
    end
  end
end
