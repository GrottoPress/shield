module Shield::SendWelcomeEmail
  macro included
    before_save do
      send_user_welcome_email
    end

    after_commit send_welcome_email

    private def send_user_welcome_email
      return unless user_email?
      mail_later UserWelcomeEmail, self
    end

    private def send_welcome_email(user : Shield::User)
      mail_later WelcomeEmail, self, user
    end
  end
end
