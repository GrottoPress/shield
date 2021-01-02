# Implements Bearer authentication as defined
# in [RFC 6750](https://tools.ietf.org/html/rfc6750)
module Shield::Api::LoginPipes
  macro included
    include Shield::LoginPipes

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

    def pin_login_to_ip_address
      if logged_out? ||
        current_login!.ip_address == remote_ip.try &.address
        continue
      else
        LogUserOut.update!(current_login!)
        response.status_code = 403
        do_pin_login_to_ip_address_failed
      end
    end

    def enforce_login_idle_timeout
      continue
    end

    def do_require_logged_in_failed
      json({status: "failure", message: "Invalid token"})
    end

    def do_require_logged_out_failed
      json({status: "failure", message: "You already have a valid token"})
    end

    def do_pin_login_to_ip_address_failed
      json({
        status: "failure",
        message: "Your IP address has changed. Please log in again."
      })
    end

    def do_enforce_login_idle_timeout_failed
      json({
        status: "failure",
        message: "Your login timed out"
      })
    end

    private def send_invalid_token_response
      response.status_code = 401
      response.headers["WWW-Authenticate"] =
        %(Bearer error="invalid_token", scope="#{bearer_scope}")
    end

    private def bearer_scope
      BearerScope.new(self.class).name
    end
  end
end
