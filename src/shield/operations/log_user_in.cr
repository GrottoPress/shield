module Shield::LogUserIn
  macro included
    attribute email : String
    attribute password : String
    attribute remember_login : Bool

    needs session : Lucky::Session
    needs cookies : Lucky::CookieJar

    before_save do
      downcase_email

      validate_credentials

      set_started_at
      set_ended_at
    end

    after_commit set_session
    after_commit remember_login
    after_commit notify_login

    private def downcase_email
      email.value.try { |value| email.value = value.downcase }
    end

    private def validate_credentials
      if user = Login.authenticate(email.value.to_s, password.value.to_s)
        user_id.value = user.not_nil!.id
      else
        email.add_error "may be incorrect"
        password.add_error "may be incorrect"
      end
    end

    private def set_started_at
      started_at.value = Time.utc
    end

    private def set_ended_at
      ended_at.value = nil
    end

    private def set_session(login : Login)
      login.set_session(session)
    end

    private def remember_login(login : Login)
      login.remember(cookies) if remember_login.value
    end

    private def notify_login(login : Login)
      return unless login.user!.options!.login_notify

      mail_later LoginNotificationEmail, self, login
    end
  end
end
