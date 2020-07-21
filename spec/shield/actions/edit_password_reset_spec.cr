require "../../spec_helper"

describe Shield::EditPasswordReset do
  it "succeeds" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    StartPasswordReset.create(user_email: email) do |operation, password_reset|
      password_reset = password_reset.not_nil!

      response = AppClient.exec(PasswordResets::Show.with(
        id: password_reset.id,
        token: operation.token
      ))

      response.status.should eq(HTTP::Status::FOUND)

      cookies = Lucky::CookieJar.from_request_cookies(response.cookies)
      session = Lucky::Session.from_cookie_jar(cookies)

      session.get?(:password_reset_id).should eq(password_reset.id.to_s)
      session.get?(:password_reset_token).should eq(operation.token)
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
    response = client.exec(PasswordResets::Edit)

    body(response)["status"]?.should be_nil
  end
end
