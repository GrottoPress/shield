module Shield::LogUserIn
  macro included
    attribute email : String
    attribute password : String

    include Shield::StartAuthentication
    include Shield::SetSession

    before_save do
      set_inactive_at

      validate_email_required
      validate_password_required
      validate_email_valid

      verify_login
    end

    include Shield::RequireIpAddress

    private def validate_email_required
      validate_required email,
        message: Rex.t(:"operation.error.email_required")
    end

    private def validate_password_required
      validate_required password,
        message: Rex.t(:"operation.error.password_required")
    end

    private def validate_email_valid
      validate_email email, message: Rex.t(
        :"operation.error.email_invalid",
        email: email.value
      )
    end

    private def set_inactive_at
      active_at.value.try do |value|
        inactive_at.value = value + Shield.settings.login_expiry
      end
    end

    private def verify_login
      return unless email.valid?

      email.value.try do |_email|
        password.value.try do |_password|
          if user = PasswordAuthentication.new(_email).verify(_password)
            user_id.value = user.id
          else
            password.add_error Rex.t(:"operation.error.login_failed")
          end
        end
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
