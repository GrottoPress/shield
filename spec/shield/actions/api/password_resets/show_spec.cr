require "../../../../spec_helper"

describe Shield::Api::PasswordResets::Show do
  it "shows password reset" do
    email = "user@example.tld"

    UserFactory.create &.email(email)

    StartPasswordReset.create(
      params(email: email),
      remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
    ) do |operation, password_reset|
      password_reset.should be_a(PasswordReset)
      password_reset = password_reset.not_nil!

      token = BearerToken.new(operation, password_reset)

      response = ApiClient.exec(
        Api::PasswordResets::Show.with(token: token)
      )

      response.should send_json(200, {status: "success"})
    end
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::PasswordResets::Show.with(token: "2.abcdef"))

    response.should send_json(200, logged_in: true)
  end
end
