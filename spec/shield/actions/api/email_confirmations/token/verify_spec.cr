require "../../../../../spec_helper"

describe Shield::Api::EmailConfirmations::Token::Verify do
  it "verifies email confirmation" do
    email = "user@example.tld"
    new_email = "user@domain.net"
    ip_address = Socket::IPAddress.new("1.2.3.4", 5)

    user = UserFactory.create &.email(email)
    UserOptionsFactory.create &.user_id(user.id)

    StartEmailConfirmation.create(
      params(email: new_email),
      user_id: user.id,
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation = email_confirmation.not_nil!

      token = EmailConfirmationCredentials.new(operation, email_confirmation)

      response = ApiClient.exec(
        Api::EmailConfirmations::Token::Verify,
        token: token
      )

      response.should send_json(200, {
        message: "action.email_confirmation.verify.success"
      })
    end
  end

  it "rejects invalid email confirmation token" do
    email = "user@domain.tld"
    password = "password4APASSWORD<"

    token = EmailConfirmationCredentials.new("abcdef", 1)

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::EmailConfirmations::Token::Verify, token: token)

    response.should send_json(200, {status: "failure"})
  end
end
