class OauthAccessTokenNotificationEmail < BaseEmail
  def initialize(
    @operation : BearerLogin::SaveOperation,
    @bearer_login : BearerLogin
  )
  end

  private def receivers
    @bearer_login.user
  end

  private def heading
    "New OAuth access token created"
  end

  private def text_message
    <<-TEXT
    New OAuth access token created
    TEXT
  end
end
