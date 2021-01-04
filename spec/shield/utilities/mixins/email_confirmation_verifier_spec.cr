require "../../../spec_helper"

describe Shield::EmailConfirmationVerifier do
  describe "#verify" do
    it "verifies email confirmation" do
      StartEmailConfirmation.create(
        params(email: "user@example.tld"),
        remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
      ) do |operation, email_confirmation|
        email_confirmation = email_confirmation.not_nil!

        session = Lucky::Session.new
        session_2 = Lucky::Session.new

        EmailConfirmationSession.new(session).set(operation, email_confirmation)
        EmailConfirmationSession.new(session_2).set("abcdefghi", 1)

        EmailConfirmationSession.new(session)
          .verify
          .should be_a(EmailConfirmation)

        EmailConfirmationSession.new(session_2).verify.should be_nil
      end
    end
  end
end
