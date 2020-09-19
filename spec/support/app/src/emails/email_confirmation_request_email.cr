class EmailConfirmationRequestEmail < BaseEmail
  def initialize(
    @operation : StartEmailConfirmation,
    @email_confirmation : EmailConfirmation
  ) : Nil
  end

  private def receivers
    Carbon::Address.new(@email_confirmation.email)
  end

  private def heading
    "Confirm your email"
  end

  private def text_message : String
    <<-TEXT
    #{@email_confirmation.url(@operation)}
    TEXT
  end
end
