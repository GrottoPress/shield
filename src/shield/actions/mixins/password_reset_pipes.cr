module Shield::PasswordResetPipes
  macro included
    def pin_password_reset_to_ip_address
      password_reset = PasswordResetSession.new(session).password_reset?

      if password_reset.nil? ||
        !password_reset.not_nil!.status.active? ||
        password_reset.not_nil!.ip_address == remote_ip?.try &.address
        continue
      else
        EndPasswordReset.update!(password_reset.not_nil!, session: session)
        response.status_code = 403
        do_pin_password_reset_to_ip_address_failed
      end
    end

    def do_pin_password_reset_to_ip_address_failed
      flash.failure = Rex.t(:"action.pipe.ip_address_changed")
      redirect to: PasswordResets::New
    end
  end
end
