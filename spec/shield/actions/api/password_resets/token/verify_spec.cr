require "../../../../../spec_helper"

describe Shield::Api::PasswordResets::Token::Verify do
  it "verifies password reset" do
    password = "password4APASSWORD<"
    token = "a1b2c3"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)
    password_reset = PasswordResetFactory.create &.user_id(user.id).token(token)

    credentials = PasswordResetCredentials.new(token, password_reset.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(
      Api::PasswordResets::Token::Verify,
      token: credentials
    )

    response.should send_json(200, {
      message: "action.password_reset.verify.success"
    })
  end

  it "rejects invalid password reset token" do
    email = "user@domain.tld"
    password = "password4APASSWORD<"

    credentials = PasswordResetCredentials.new("abcdef", 1)

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(
      Api::PasswordResets::Token::Verify,
      token: credentials
    )

    response.should send_json(403, {status: "failure"})
  end

  it "requires logged in" do
    credentials = PasswordResetCredentials.new("abcdef", 1)

    response = ApiClient.exec(
      Api::PasswordResets::Token::Verify,
      token: credentials
    )

    response.should send_json(401, logged_in: false)
  end
end
