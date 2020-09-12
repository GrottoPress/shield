abstract class BaseEmail < Carbon::Email
  from sender
  to receivers
  subject heading

  def sender
    default_sender
  end

  abstract def receivers

  abstract def heading

  def text_body
    text_message
  end

  private abstract def text_message

  private def default_sender
    Carbon::Address.new("Shield", "noreply@example.tld")
  end
end
