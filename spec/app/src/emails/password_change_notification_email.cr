class PasswordChangeNotificationEmail < BaseEmail
  def initialize(@user : User) : Nil
  end

  private def receivers
    @user
  end

  private def heading
    "Your password was recently changed"
  end

  private def text_message : String
    <<-TEXT
    Your password was recently changed
    TEXT
  end
end
