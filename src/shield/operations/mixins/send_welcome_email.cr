module Shield::SendWelcomeEmail
  macro included
    before_save do
      send_user_welcome_email
    end

    after_commit send_welcome_email

    private def send_user_welcome_email
      return unless user_email?
      UserWelcomeEmail.new(self).deliver_later
    end

    private def send_welcome_email(user : Shield::User)
      WelcomeEmail.new(self, user).deliver_later
    end
  end
end
