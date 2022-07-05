require "../../../../spec_helper"

describe Shield::Api::EmailConfirmations::Show do
  it "shows email confirmation" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    email_confirmation = EmailConfirmationFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::EmailConfirmations::Show.with(
      email_confirmation_id: email_confirmation.id
    ))

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::EmailConfirmations::Show.with(
      email_confirmation_id: 5
    ))

    response.should send_json(401, logged_in: false)
  end
end
