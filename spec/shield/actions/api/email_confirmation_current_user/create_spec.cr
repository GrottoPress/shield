require "../../../../spec_helper"

describe Shield::Api::EmailConfirmationCurrentUser::Create do
  it "creates user" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    StartEmailConfirmation.create(
      params(email: email),
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation = email_confirmation.not_nil!

      token = EmailConfirmationHelper.token(email_confirmation, operation)

      response = ApiClient.exec(
        Api::EmailConfirmationCurrentUser::Create,
        token: token,
        user: {
          password: password,
          password_notify: true,
          login_notify: true
        }
      )

      response.should send_json(200, {status: "success"})
    end
  end

  it "rejects invalid email confirmation token" do
    password = "password4APASSWORD<"
    token = EmailConfirmationHelper.token(1, "abcdef")

    response = ApiClient.exec(
      Api::EmailConfirmationCurrentUser::Create,
      token: token,
      user: {
        password: password,
        password_notify: true,
        login_notify: true
      }
    )

    response.should send_json(403, {status: "failure"})
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::EmailConfirmationCurrentUser::Create, user: {
      password: password,
      password_notify: true,
      login_notify: true
    })

    response.should send_json(200, logged_in: true)
  end
end
