class UserEmailConfirmationRequestEmail < BaseEmail
  def initialize(@operation : StartEmailConfirmation) : Nil
  end

  private def receivers
    Carbon::Address.new(@operation.email.to_s)
  end

  private def heading
    "Email change attempt failed"
  end

  private def text_message : String
    <<-TEXT
    Email change attempt failed
    TEXT
  end
end
