require "../../../spec_helper"

describe Shield::EmailConfirmations::Edit do
  it "updates email confirmation user" do
    email = "user@example.tld"
    new_email = "user@domain.net"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    user = UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    StartEmailConfirmation.create(
      params(email: new_email),
      user_id: user.id,
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation = email_confirmation.not_nil!
      session = Lucky::Session.new

      EmailConfirmationSession.new(session).set(operation, email_confirmation)

      client = ApiClient.new
      client.browser_auth(user, password, session: session)

      response = client.exec(EmailConfirmations::Edit)

      user.reload.email.should eq(new_email)
    end
  end

  it "rejects invalid email confirmation token" do
    email = "user@domain.tld"
    password = "password4APASSWORD<"

    session = Lucky::Session.new
    EmailConfirmationSession.new(session).set("abcdef", 1)

    client = ApiClient.new
    client.browser_auth(email, password, session: session)

    response = client.exec(EmailConfirmations::Edit)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Email-Confirmation-Status"]?.should eq("failure")
  end

  it "requires logged in" do
    response = ApiClient.exec(EmailConfirmations::Edit)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"].should eq("false")
  end
end
