require "../../../spec_helper"

describe Shield::EmailConfirmations::Edit do
  it "works" do
    email = "user@example.tld"
    new_email = "user@domain.net"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    user = UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password))

    StartEmailConfirmation.create(
      params(email: new_email),
      user_id: user.id,
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation = email_confirmation.not_nil!
      session = Lucky::Session.new

      EmailConfirmationSession.new(session).set(email_confirmation, operation)

      client = ApiClient.new
      client.browser_auth(user, password, session: session)

      response = client.exec(EmailConfirmations::Edit)

      response.status.should eq(HTTP::Status::FOUND)
    end

    user.reload.email.should eq(new_email)
  end

  it "requires logged in" do
    response = ApiClient.exec(EmailConfirmations::Edit)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"].should eq("false")
  end
end
