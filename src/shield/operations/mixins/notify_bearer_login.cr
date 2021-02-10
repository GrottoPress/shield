module Shield::NotifyBearerLogin
  macro included
    after_commit notify_bearer_login

    private def notify_bearer_login(bearer_login : BearerLogin)
      return unless bearer_login.user!.options!.bearer_login_notify

      mail_later BearerLoginNotificationEmail, self, bearer_login
    end
  end
end
