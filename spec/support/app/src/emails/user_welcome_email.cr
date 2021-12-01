class UserWelcomeEmail < BaseEmail
  def initialize(@operation : User::SaveOperation) : Nil
  end

  private def receivers
    Carbon::Address.new(@operation.email.value.to_s)
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
