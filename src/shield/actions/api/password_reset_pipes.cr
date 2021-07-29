module Shield::Api::PasswordResetPipes
  macro included
    include Shield::PasswordResetPipes

    def pin_password_reset_to_ip_address
      password_reset = PasswordResetParams.new(params).password_reset?

      if password_reset.nil? ||
        !password_reset.not_nil!.active? ||
        password_reset.not_nil!.ip_address == remote_ip?.try &.address
        continue
      else
        EndPasswordReset.update!(password_reset.not_nil!, session: nil)
        response.status_code = 403
        do_pin_password_reset_to_ip_address_failed
      end
    end

    def do_pin_password_reset_to_ip_address_failed
      json({
        status: "failure",
        message: "Your IP address has changed. Please try again."
      })
    end
  end
end
