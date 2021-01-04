require "../../spec_helper"

describe Shield::EmailConfirmationPipes do
  describe "#pin_email_confirmation_to_ip_address" do
    it "accepts email confirmation from same IP" do
      StartEmailConfirmation.create(
        params(email: "user@example.tld"),
        remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
      ) do |operation, email_confirmation|
        email_confirmation = email_confirmation.not_nil!

        session = Lucky::Session.new
        EmailConfirmationSession.new(session).set(operation, email_confirmation)

        client = ApiClient.new
        client.set_cookie_from_session(session)

        response = client.exec(EmailConfirmationCurrentUser::New)

        response.body.should eq("EmailConfirmationCurrentUser::NewPage")
      end
    end

    it "rejects email confirmation from different IP" do
      StartEmailConfirmation.create(
        params(email: "user@example.tld"),
        remote_ip: Socket::IPAddress.new("129.0.0.3", 9000)
      ) do |operation, email_confirmation|
        email_confirmation = email_confirmation.not_nil!

        session = Lucky::Session.new
        EmailConfirmationSession.new(session).set(operation, email_confirmation)

        client = ApiClient.new
        client.set_cookie_from_session(session)

        response = client.exec(EmailConfirmationCurrentUser::New)

        response.status.should eq(HTTP::Status::FOUND)
        response.headers["X-Ip-Address-Changed"].should eq("true")
      end
    end
  end
end
