class GuestPasswordResetRequestEmail < BaseEmail
  def initialize(@operation : SavePasswordReset) : Nil
  end

  private def receivers
    Carbon::Address.new(@operation.user_email.to_s)
  end

  private def heading
    "Password reset attempt failed"
  end

  private def text_message : String
    <<-TEXT
    Password reset attempt failed
    TEXT
  end
end
