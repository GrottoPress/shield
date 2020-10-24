require "../../spec_helper"

describe Shield::EndEmailConfirmation do
  it "ends email confirmation" do
    session = Lucky::Session.new

    StartEmailConfirmation.create(
      params(email: "james@domain.net"),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    ) do |operation, email_confirmation|
      email_confirmation =  email_confirmation.not_nil!

      EmailConfirmationSession.new(session).set(email_confirmation, operation)

      EndEmailConfirmation.update(
        email_confirmation,
        params(status: "Started"),
        status: EmailConfirmation::Status.new(:expired),
        session: session
      ) do |operation, updated_email_confirmation|
        operation.saved?.should be_true

        updated_email_confirmation.ended_at.should_not be_nil
        updated_email_confirmation.status.expired?.should be_true
      end
    end

    EmailConfirmationSession.new(session).email_confirmation_id.should be_nil
    EmailConfirmationSession.new(session).email_confirmation_token.should be_nil
  end
end
