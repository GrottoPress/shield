require "../../../../spec_helper"

describe Shield::Api::EmailConfirmations::Edit do
  it "updates email confirmation user" do
    email = "user@example.tld"
    new_email = "user@domain.net"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("1.2.3.4", 5)

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)

    StartEmailConfirmation.create(
      params(email: new_email),
      user_id: user.id,
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation = email_confirmation.not_nil!

      token = BearerToken.new(operation, email_confirmation)

      client = ApiClient.new
      client.api_auth(user, password)

      response = client.exec(Api::EmailConfirmations::Edit, token: token)

      response.should send_json(200, {
        message: "action.email_confirmation.edit.success"
      })

      user.reload.email.should eq(new_email)
    end
  end

  it "rejects invalid email confirmation token" do
    email = "user@domain.tld"
    password = "password4APASSWORD<"

    token = BearerToken.new("abcdef", 1)

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::EmailConfirmations::Edit, token: token)

    response.should send_json(403, {status: "failure"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::EmailConfirmations::Edit, token: "1.abcdef")

    response.should send_json(401, logged_in: false)
  end
end
