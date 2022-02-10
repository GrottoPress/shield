require "../../../../spec_helper"

describe Shield::Api::PasswordResets::Create do
  it "starts password reset" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    UserFactory.create &.email(email).password(password)

    response = ApiClient.exec(Api::PasswordResets::Create, password_reset: {
      email: email
    })

    response.should send_json(200, {message: "action.misc.dev_mode_skip_email"})
  end

  it "succeeds even if email does not exist" do
    email = "user@example.tld"

    response = ApiClient.exec(Api::PasswordResets::Create, password_reset: {
      email: email
    })

    response.should send_json(
      200,
      {message: "action.password_reset.create.success"}
    )
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::PasswordResets::Create, password_reset: {
      email: email
    })

    response.should send_json(200, logged_in: true)
  end
end
