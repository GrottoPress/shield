require "../../../../spec_helper"

describe Shield::Api::PasswordResets::Create do
  it "starts password reset" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    UserFactory.create &.email(email).password(password)

    response = ApiClient.exec(Api::PasswordResets::Create, password_reset: {
      email: email
    })

    response.should send_json(200, {status: "success"})
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
