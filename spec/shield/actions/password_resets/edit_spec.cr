require "../../../spec_helper"

describe Shield::PasswordResets::Edit do
  it "renders edit form" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    UserOptionsBox.create &.user_id(user.id)

    StartPasswordReset.create(
      params(email: email),
      remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
    ) do |operation, password_reset|
      password_reset = password_reset.not_nil!

      session = Lucky::Session.new
      PasswordResetSession.new(session).set(operation, password_reset)

      client = ApiClient.new
      client.set_cookie_from_session(session)

      response = client.exec(PasswordResets::Edit)

      response.body.should eq("PasswordResets::EditPage")
    end
  end

  it "rejects invalid password reset token" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    UserOptionsBox.create &.user_id(user.id)

    password_reset = StartPasswordReset.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
    )

    session = Lucky::Session.new
    PasswordResetSession.new(session).set("abcdef", password_reset.id)

    client = ApiClient.new
    client.set_cookie_from_session(session)

    response = client.exec(PasswordResets::Edit)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Password-Reset-Status"]?.should eq("failure")
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(PasswordResets::Edit)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"].should eq("true")
  end
end
