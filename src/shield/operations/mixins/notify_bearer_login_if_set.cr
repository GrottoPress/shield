module Shield::NotifyBearerLoginIfSet
  macro included
    after_commit notify_bearer_login

    private def notify_bearer_login(bearer_login : Shield::BearerLogin)
      bearer_login = BearerLoginQuery.preload_user(bearer_login)
      return unless bearer_login.user.settings.bearer_login_notify?

      BearerLoginNotificationEmail.new(self, bearer_login).deliver_later
    end
  end
end
