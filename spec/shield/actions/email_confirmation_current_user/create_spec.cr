require "../../../spec_helper"

describe Shield::EmailConfirmationCurrentUser::Create do
  it "creates user" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("1.2.3.4", 5)

    StartEmailConfirmation.create(
      params(email: email),
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation = email_confirmation.not_nil!
      session = Lucky::Session.new

      EmailConfirmationSession.new(session).set(operation, email_confirmation)

      client = ApiClient.new
      client.set_cookie_from_session(session)

      response = client.exec(EmailConfirmationCurrentUser::Create, user: {
        password: password,
        password_notify: true,
        login_notify: true
      })

      response.headers["X-User-ID"]?.should eq("ec_user_id")
    end
  end

  it "rejects invalid email confirmation token" do
    password = "password4APASSWORD<"

    session = Lucky::Session.new
    EmailConfirmationSession.new(session).set("abcdef", 1)

    client = ApiClient.new
    client.set_cookie_from_session(session)

    response = client.exec(EmailConfirmationCurrentUser::Create, user: {
      password: password,
      password_notify: true,
      login_notify: true
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Email-Confirmation-Status"]?.should eq("failure")
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(EmailConfirmationCurrentUser::Create, user: {
      password: password,
      password_notify: true,
      login_notify: true
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("true")
  end
end
