class LoginNotificationEmail < BaseEmail
  def initialize(@operation : Shield::LogUserIn, @login : Login)
  end

  private def receivers
    @login.user
  end

  private def heading
    "Someone logged in into your account"
  end

  private def text_message : String
    <<-TEXT
    Someone logged in into your account
    TEXT
  end
end
