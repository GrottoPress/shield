require "../../../../spec_helper"

describe Shield::Api::EmailConfirmations::Create do
  it "creates email confirmation" do
    response = ApiClient.exec(
      Api::EmailConfirmations::Create,
      email_confirmation: {email: "user@domain.tld"}
    )

    response.should send_json(200, {message: "action.misc.dev_mode_skip_email"})
  end

  it "succeeds even if email already taken" do
    email = "user@domain.net"

    UserFactory.create &.email(email)

    response = ApiClient.exec(
      Api::EmailConfirmations::Create,
      email_confirmation: {email: email}
    )

    response.should send_json(
      200,
      {message: "action.email_confirmation.create.success"}
    )
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(
      Api::EmailConfirmations::Create,
      email_confirmation: {email: "user@domain.tld"}
    )

    response.should send_json(200, logged_in: true)
  end
end
