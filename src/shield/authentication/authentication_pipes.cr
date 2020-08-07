module Shield::AuthenticationPipes
  macro included
    def require_logged_in
      if logged_in?
        continue
      else
        require_logged_in_action
      end
    end

    def require_logged_out
      if logged_out?
        continue
      else
        require_logged_out_action
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

    def require_logged_in_action
      flash.failure = "You are not logged in"
      redirect to: Logins::New
    end

    def require_logged_out_action
      flash.info = "You are already logged in"
      redirect_back fallback: CurrentUser::Show
    end
  end
end
