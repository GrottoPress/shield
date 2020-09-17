require "../../../spec_helper"

describe Shield::PasswordResets::Show do
  it "works" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password, 4))

    StartPasswordReset.create(
      params(email: email),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, password_reset|
      password_reset = password_reset.not_nil!

      response = ApiClient.get(PasswordResetHelper.password_reset_url(
        password_reset,
        operation
      ))

      response.status.should eq(HTTP::Status::FOUND)

      cookies = Lucky::CookieJar.from_request_cookies(response.cookies)
      session = Lucky::Session.from_cookie_jar(cookies)

      PasswordResetSession
        .new(session)
        .password_reset_id
        .should eq(password_reset.id)

      PasswordResetSession
        .new(session)
        .password_reset_token
        .should eq(operation.token)
    end
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password, 4))

    client = ApiClient.new

    response = client.exec(Logins::Create, login: {
      email: email,
      password: password
    })

    response.should send_json(200, session: 1)

    client.headers("Cookie": response.headers["Set-Cookie"])
    response = client.get(PasswordResetHelper.password_reset_url(
      1_i64,
      "abcdef"
    ))

    response.should send_json(200, logged_in: true)
  end
end
