require "../../../../spec_helper"

describe Shield::Api::EmailConfirmations::Show do
  it "shows email confirmation" do
    StartEmailConfirmation.create(
      params(email: "user@example.tld"),
      remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
    ) do |operation, email_confirmation|
      email_confirmation.should be_a(EmailConfirmation)
      email_confirmation = email_confirmation.not_nil!

      token = BearerToken.new(operation, email_confirmation)

      response = ApiClient.exec(
        Api::EmailConfirmations::Show.with(token: token)
      )

      response.should send_json(200, {status: "success"})
    end
  end

  it "shows email confirmation for logged in user" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    StartEmailConfirmation.create(
      params(email: "user@example.tld"),
      remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
    ) do |operation, email_confirmation|
      email_confirmation.should be_a(EmailConfirmation)
      email_confirmation = email_confirmation.not_nil!

      token = BearerToken.new(operation, email_confirmation)

      client = ApiClient.new
      client.api_auth(user, password)

      response = client.exec(Api::EmailConfirmations::Show.with(token: token))

      response.should send_json(200, {status: "success"})
    end
  end
end
