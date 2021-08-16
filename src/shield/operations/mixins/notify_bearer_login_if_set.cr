module Shield::NotifyBearerLoginIfSet
  macro included
    after_commit notify_bearer_login

    private def notify_bearer_login(bearer_login : Shield::BearerLogin)
      return unless bearer_login.user!.settings.bearer_login_notify?

      mail_later BearerLoginNotificationEmail, self, bearer_login
    end
  end
end
