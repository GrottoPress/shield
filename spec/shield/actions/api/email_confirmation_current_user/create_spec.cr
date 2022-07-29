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

      token = EmailConfirmationCredentials.new(operation, email_confirmation)

      response = ApiClient.exec(
        Api::CurrentUser::Create,
        token: token,
        user: {password: password},
        user_options: {
          password_notify: true,
          login_notify: true,
          bearer_login_notify: true
        }
      )

      response.should send_json(200, {
        message: "action.current_user.create.success"
      })
    end
  end

  it "rejects invalid email confirmation token" do
    password = "password4APASSWORD<"
    token = EmailConfirmationCredentials.new("abcdef", 1)

    response = ApiClient.exec(
      Api::CurrentUser::Create,
      token: token,
      user: {password: password},
      user_options: {
        password_notify: true,
        login_notify: true,
        bearer_login_notify: true
      }
    )

    response.should send_json(403, {status: "failure"})
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(
      Api::CurrentUser::Create,
      user: {password: password},
      user_options: {
        password_notify: true,
        login_notify: true,
        bearer_login_notify: true
      }
    )

    response.should send_json(200, logged_in: true)
  end
end
