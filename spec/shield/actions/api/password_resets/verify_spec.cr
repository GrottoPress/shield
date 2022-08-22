require "../../../../spec_helper"

describe Shield::Api::PasswordResets::Verify do
  it "verifies password reset" do
    email = "user@example.tld"

    UserFactory.create &.email(email)

    StartPasswordReset.create(
      params(email: email),
      remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
    ) do |operation, password_reset|
      password_reset = password_reset.not_nil!

      token = PasswordResetCredentials.new(operation, password_reset)
      response = ApiClient.exec(Api::PasswordResets::Verify, token: token)

      response.should send_json(200, {
        message: "action.password_reset.verify.success"
      })
    end
  end

  it "rejects invalid password reset token" do
    token = PasswordResetCredentials.new("abcdef", 1)

    response = ApiClient.exec(Api::PasswordResets::Verify, token: token)
    response.should send_json(200, {status: "failure"})
  end
end
