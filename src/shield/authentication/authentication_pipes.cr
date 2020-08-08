module Shield::AuthenticationPipes
  macro included
    def require_logged_in
      if logged_in?
        continue
      else
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

    def set_no_referrer_policy
      response.headers["Referrer-Policy"] = "no-referrer"
      continue
    end

    def disable_caching
      response.headers["Cache-Control"] = "no-store"
      response.headers["Expires"] = Time::UNIX_EPOCH.to_s
      continue
    end

    def do_require_logged_in_failed
      flash.failure = "You are not logged in"
      redirect to: Logins::New
    end

    def do_require_logged_out_failed
      flash.info = "You are already logged in"
      redirect_back fallback: CurrentUser::Show
    end
  end
end
