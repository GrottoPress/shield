module Shield::StartLogin
  macro included
    attribute email : String
    attribute password : String

    include Lucille::Activate
    include Shield::SetToken
    include Shield::SetSession
    include Shield::SetIpAddressFromRemoteAddress

    before_save do
      set_inactive_at
    end

    include Shield::ValidateLogin

    before_save do
      verify_login
    end

    private def set_inactive_at
      Shield.settings.login_expiry.try do |expiry|
        active_at.value.try { |value| inactive_at.value = value + expiry }
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
