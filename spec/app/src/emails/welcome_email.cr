class WelcomeEmail < BaseEmail
  def initialize(@operation : RegisterCurrentUser, @user : User) : Nil
  end

  private def receivers
    @user
  end

  private def heading
    "Welcome"
  end

  private def text_message : String
    <<-TEXT
    Welcome
    TEXT
  end
end
