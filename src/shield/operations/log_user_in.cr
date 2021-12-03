module Shield::LogUserIn
  macro included
    attribute email : String
    attribute password : String

    before_save do
      validate_email_required
      validate_password_required
      validate_email_valid

      verify_login
    end

    include Shield::RequireIpAddress
    include Shield::StartAuthentication
    include Shield::SetSession

    private def validate_email_required
      validate_required email
    end

    private def validate_password_required
      validate_required password
    end

    private def validate_email_valid
      validate_email email
    end

    private def set_default_inactive_at
      active_at.value.try do |value|
        inactive_at.value = value + Shield.settings.login_expiry
      end
    end

    private def verify_login
      email.value.try do |_email|
        password.value.try do |_password|
          if user = PasswordAuthentication.new(_email).verify(_password)
            user_id.value = user.id
          else
            email.add_error "may be incorrect"
            password.add_error "may be incorrect"
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
