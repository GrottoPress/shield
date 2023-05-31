require "../../../../spec_helper"

describe Shield::PasswordResets::Token::Show do
  it "sets session" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)

    StartPasswordReset.create(
      params(email: email),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, password_reset|
      password_reset = password_reset.not_nil!

      response = ApiClient.get(PasswordResetCredentials.url(
        operation,
        password_reset
      ))

      response.status.should eq(HTTP::Status::FOUND)

      session = ApiClient.session_from_cookies(response.cookies)

      PasswordResetSession
        .new(session)
        .password_reset_id?
        .should eq(password_reset.id)

      PasswordResetSession
        .new(session)
        .password_reset_token?
        .should eq(operation.token)
    end
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.get(PasswordResetCredentials.url("abcdef", 1_i64))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("true")
  end
end
