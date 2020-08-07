require "../../../spec_helper"

describe Shield::PasswordResets::Show do
  it "works" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    StartPasswordReset.create(
      email: email,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, password_reset|
      password_reset = password_reset.not_nil!

      response = AppClient.get(PasswordResetHelper.password_reset_url(
        operation,
        password_reset
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

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    client = AppClient.new

    response = client.exec(Logins::Create, login: {
      email: email,
      password: password
    })

    body(response)["session"]?.should_not be_nil

    client.headers("Cookie": response.headers["Set-Cookie"])
    response = client.get(PasswordResetHelper.password_reset_url(
      1_i64,
      "abcdef"
    ))

    body(response)["logged_in"]?.should be_true
  end
end
