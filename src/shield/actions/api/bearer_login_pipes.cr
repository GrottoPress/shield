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
      if logged_out? && bearer_logged_out? ||
        logged_in? && authorize?(current_user) ||
        bearer_logged_in? && authorize?(current_bearer)

        continue
      else
        response.status_code = 403
        do_check_authorization_failed
      end
    end

    private def send_invalid_token_response
      unless BearerLoginCredentials.from_headers?(request)
        response.status_code = 401
        return response.headers["WWW-Authenticate"] = %(Bearer)
      end

      if BearerLoginHeaders.new(request).verify?
        response.status_code = 403
        response.headers["WWW-Authenticate"] =
          %(Bearer error="insufficient_scope", scope="#{bearer_scope}")
      else
        response.status_code = 401
        response.headers["WWW-Authenticate"] = %(Bearer error="invalid_token")
      end
    end
  end
end
