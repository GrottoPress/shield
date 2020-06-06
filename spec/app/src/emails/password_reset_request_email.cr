class PasswordResetRequestEmail < BaseEmail
  def initialize(
    @operation : SavePasswordReset,
    @password_reset : PasswordReset
  ) : Nil
  end

  private def receivers
    @password_reset.user!
  end

  private def heading
    "Reset your password"
  end

  private def text_message : String
    <<-TEXT
    #{@password_reset.url(@token)}
    TEXT
  end
end
