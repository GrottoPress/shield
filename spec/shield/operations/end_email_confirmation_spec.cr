require "../../spec_helper"

describe Shield::EndEmailConfirmation do
  it "ends email confirmation" do
    session = Lucky::Session.new

    StartEmailConfirmation.create(
      params(email: "james@domain.net"),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    ) do |operation, email_confirmation|
      email_confirmation.should be_a(EmailConfirmation)
      email_confirmation =  email_confirmation.not_nil!

      EmailConfirmationSession.new(session).set(operation, email_confirmation)

      email_confirmation.status.active?.should be_true

      EndEmailConfirmation.update(
        email_confirmation,
        session: session
      ) do |_operation, updated_email_confirmation|
        _operation.saved?.should be_true

        updated_email_confirmation.status.active?.should be_false
      end
    end

    EmailConfirmationSession.new(session).email_confirmation_id?.should be_nil

    EmailConfirmationSession.new(session)
      .email_confirmation_token?
      .should(be_nil)
  end
end
