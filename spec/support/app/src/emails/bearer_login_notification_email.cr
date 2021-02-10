class BearerLoginNotificationEmail < BaseEmail
  def initialize(@operation : CreateBearerLogin, @bearer_login : BearerLogin)
  end

  private def receivers
    @bearer_login.user!
  end

  private def heading
    "New bearer login created"
  end

  private def text_message : String
    <<-TEXT
    New bearer login token created
    TEXT
  end
end
