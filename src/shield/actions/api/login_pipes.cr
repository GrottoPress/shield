module Shield::Api::LoginPipes
  macro included
    include Shield::LoginPipes

    def pin_login_to_ip_address
      if logged_out? ||
        current_login.ip_address == remote_ip?.try &.address
        continue
      else
        LogUserOut.update!(current_login, session: nil)
        response.status_code = 403
        do_pin_login_to_ip_address_failed
      end
    end

    def enforce_login_idle_timeout
      continue
    end

    def do_require_logged_in_failed
      json({status: "failure", message: Rex.t(:"action.pipe.not_logged_in")})
    end

    def do_require_logged_out_failed
      json({status: "failure", message: Rex.t(:"action.pipe.not_logged_out")})
    end

    def do_pin_login_to_ip_address_failed
      json({
        status: "failure",
        message: Rex.t(:"action.pipe.ip_address_changed")
      })
    end

    def do_enforce_login_idle_timeout_failed
      json({
        status: "failure",
        message: Rex.t(:"action.pipe.login_timed_out")
      })
    end

    def do_check_authorization_failed
      json({
        status: "failure",
        message: Rex.t(:"action.pipe.authorization_failed")
      })
    end
  end
end
