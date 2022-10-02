require "../../../../../spec_helper"

describe Shield::Api::EmailConfirmations::Token::Verify do
  it "verifies email confirmation" do
    email = "user@example.tld"
    new_email = "user@domain.net"
    password = "password4APASSWORD<"
    token = "a1b2c3"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)

    email_confirmation = EmailConfirmationFactory.create &.user_id(user.id)
      .email(new_email)
      .token(token)

    credentials = EmailConfirmationCredentials.new(token, email_confirmation.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(
      Api::EmailConfirmations::Token::Verify,
      token: credentials
    )

    response.should send_json(200, {
      message: "action.email_confirmation.verify.success"
    })
  end

  it "rejects invalid email confirmation token" do
    email = "user@domain.tld"
    password = "password4APASSWORD<"

    credentials = EmailConfirmationCredentials.new("abcdef", 1)

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(
      Api::EmailConfirmations::Token::Verify,
      token: credentials
    )

    response.should send_json(200, {status: "failure"})
  end

  it "requires logged in" do
    credentials = EmailConfirmationCredentials.new("abcdef", 1)

    response = ApiClient.exec(
      Api::EmailConfirmations::Token::Verify,
      token: credentials
    )

    response.should send_json(401, logged_in: false)
  end
end
