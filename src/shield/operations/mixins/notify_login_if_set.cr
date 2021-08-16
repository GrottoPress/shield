module Shield::NotifyLoginIfSet
  macro included
    after_commit notify_login

    private def notify_login(login : Shield::Login)
      return unless login.user!.settings.login_notify?

      mail_later LoginNotificationEmail, self, login
    end
  end
end
