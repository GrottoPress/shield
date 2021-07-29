# Implements Bearer authentication as defined
# in [RFC 6750](https://tools.ietf.org/html/rfc6750)
module Shield::Api::AuthorizationPipes
  macro included
    include Shield::AuthorizationPipes

    def check_authorization
      if logged_out? && bearer_logged_out?
        continue
      elsif logged_in? && authorize?(current_user)
        continue
      elsif authorize_bearer_login? && authorize?(current_bearer_user)
        continue
      else
        send_insufficient_scope_response
        do_check_authorization_failed
      end
    end

    def do_check_authorization_failed
      json({
        status: "failure",
        message: "You are not allowed to perform this action!"
      })
    end

    private def authorize_bearer_login?
      current_bearer_login?.try &.scopes.includes?(bearer_scope)
    end

    private def send_insufficient_scope_response
      response.status_code = 403
      response.headers["WWW-Authenticate"] =
        %(Bearer error="insufficient_scope", scope="#{bearer_scope}")
    end

    private def bearer_scope
      BearerScope.new(self.class).name
    end
  end
end
