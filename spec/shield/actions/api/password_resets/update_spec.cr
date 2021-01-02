require "../../../../spec_helper"

describe Shield::Api::PasswordResets::Update do
  it "resets password" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    new_password = "assword4APASSWOR<"

    user = UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    StartPasswordReset.create(
      params(email: email),
      remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
    ) do |operation, password_reset|
      password_reset = password_reset.not_nil!

      token = BearerToken.new(operation, password_reset)

      response = ApiClient.exec(
        Api::PasswordResets::Update,
        token: token,
        user: {password: new_password}
      )

      response.should send_json(200, {status: "success"})

      BcryptHash.new(new_password)
        .verify?(user.reload.password_digest)
        .should(be_true)
    end
  end

  it "rejects invalid password reset token" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    new_password = "assword4APASSWOR<"

    UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    password_reset = StartPasswordReset.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
    )

    token = BearerToken.new("abcdef", 1)

    response = ApiClient.exec(
      Api::PasswordResets::Update,
      token: token,
      user: {password: new_password}
    )

    response.should send_json(403, {status: "failure"})
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    new_password = "assword4APASSWOR<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::PasswordResets::Update, user: {
      password: new_password
    })

    response.should send_json(200, logged_in: true)
  end
end
