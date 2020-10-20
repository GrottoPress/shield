module Shield::NotifyLogin
  macro included
    after_commit notify_login

    private def notify_login(login : Login)
      return unless login.user!.options!.login_notify

      mail_later LoginNotificationEmail, self, login
    end
  end
end
