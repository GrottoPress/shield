module Shield::LogUserIn
  macro included
    attribute email : String
    attribute password : String

    needs session : Lucky::Session

    before_save do
      validate_required email, password
      validate_credentials
    end

    after_commit set_session
    after_commit notify_login

    include Shield::ValidateEmail
    include Shield::StartAuthentication(Login)

    private def validate_credentials
      return unless email.value.to_s.email? && password.value

      VerifyUser.new(
        params,
        email: email.value.not_nil!,
        password: password.value.not_nil!
      ).submit do |operation, user|
        if user
          user_id.value = user.not_nil!.id
        else
          email.add_error "may be incorrect"
          password.add_error "may be incorrect"
        end
      end
    end

    private def set_session(login : Login)
      VerifyLogin.new(params, session: session).set_session(login.id, token)
    end

    private def notify_login(login : Login)
      return unless login.user!.options!.login_notify

      mail_later LoginNotificationEmail, self, login
    end
  end
end
