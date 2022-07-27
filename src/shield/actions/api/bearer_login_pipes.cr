# Implements Bearer authentication as defined
# in [RFC 6750](https://tools.ietf.org/html/rfc6750)
module Shield::Api::BearerLoginPipes
  macro included
    include Shield::Api::LoginPipes

    def require_logged_in
      if logged_in? || bearer_logged_in?
        continue
      else
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
      elsif logged_in? && authorize?(current_user)
        continue
      elsif authorize_bearer_login? && authorize?(current_bearer)
        continue
      else
        send_insufficient_scope_response
        do_check_authorization_failed
      end
    end

    private def authorize_bearer_login?
      current_bearer_login?.try &.scopes.includes?(bearer_scope)
    end

    private def send_insufficient_scope_response
      response.status_code = 403
      response.headers["WWW-Authenticate"] =
        %(Bearer error="insufficient_scope", scope="#{bearer_scope}")
    end

    private def send_invalid_token_response
      response.status_code = 401

      if BearerCredentials.from_headers?(request)
        response.headers["WWW-Authenticate"] = %(Bearer error="invalid_token")
      else
        response.headers["WWW-Authenticate"] = %(Bearer)
      end
    end

    private def bearer_scope
      BearerScope.new(self.class).name
    end
  end
end
