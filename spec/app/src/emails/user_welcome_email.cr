class UserWelcomeEmail < BaseEmail
  def initialize(@operation : RegisterCurrentUser) : Nil
  end

  private def receivers
    Carbon::Address.new(@operation.email.to_s)
  end

  private def heading
    "Registration failed"
  end

  private def text_message : String
    <<-TEXT
    Registration failed
    TEXT
  end
end
