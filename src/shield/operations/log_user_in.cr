module Shield::LogUserIn
  macro included
    attribute email : String
    attribute password : String

    before_save do
      validate_required email, password
      validate_email email

      verify_login
    end

    include Shield::RequireIpAddress
    include Shield::StartAuthentication
    include Shield::SetSession

    private def set_inactive_at
      inactive_at.value = active_at.value.not_nil! + \
        Shield.settings.login_expiry
    end

    private def verify_login
      return unless email.value && password.value

      if user = PasswordAuthentication.new(email.value.not_nil!)
        .verify(password.value.not_nil!)

        user_id.value = user.id
      else
        email.add_error "may be incorrect"
        password.add_error "may be incorrect"
      end
    end

    private def set_session(login : Shield::Login)
      session.try do |session|
        LoginSession.new(session).set(self, login)
        LoginIdleTimeoutSession.new(session).set
      end
    end
  end
end
