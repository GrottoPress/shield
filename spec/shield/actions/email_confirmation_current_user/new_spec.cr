require "../../../spec_helper"

describe Shield::EmailConfirmationCurrentUser::New do
  it "renders new page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    StartEmailConfirmation.create(
      params(email: email),
      remote_ip: ip_address
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

  it "rejects invalid email confirmation token" do
    password = "password4APASSWORD<"

    session = Lucky::Session.new
    EmailConfirmationSession.new(session).set("abcdef", 1)

    client = ApiClient.new
    client.set_cookie_from_session(session)

    response = ApiClient.exec(EmailConfirmationCurrentUser::New)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Email-Confirmation-Status"]?.should eq("failure")
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    client = ApiClient.new
    client.browser_auth(email, password, ip_address)

    response = client.exec(EmailConfirmationCurrentUser::New)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("true")
  end
end
