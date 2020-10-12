# Implements Bearer authentication as defined
# in [RFC 6750](https://tools.ietf.org/html/rfc6750)
module Shield::BearerAuthenticationPipes
  macro included
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

    def check_authorization
      if logged_out? && bearer_logged_out?
        continue
      elsif logged_in? && authorize?(current_user!)
        continue
      elsif authorize_bearer_login? && authorize?(current_bearer_user!)
        continue
      else
        send_insufficient_scope_response
        do_check_authorization_failed
      end
    end

    def do_require_logged_in_failed
      flash.failure = "You are not logged in"
      json({notices: flash})
    end

    def do_require_logged_out_failed
      flash.info = "You are already logged in"
      json({notices: flash})
    end

    def do_check_authorization_failed
      flash.failure = "You are not allowed to perform this action!"
      json({notices: flash})
    end

    private def authorize_bearer_login?
      current_bearer_login.try &.scopes.includes?(bearer_login_scope)
    end

    private def send_invalid_token_response
      response.status_code = 401
      response.headers["WWW-Authenticate"] =
        %(Bearer error="invalid_token", scope="#{bearer_login_scope}")
    end

    private def send_insufficient_scope_response
      response.status_code = 403
      response.headers["WWW-Authenticate"] =
        %(Bearer error="insufficient_scope", scope="#{bearer_login_scope}")
    end

    private def bearer_login_scope
      BearerLoginHelper.scope(self.class)
    end
  end
end
