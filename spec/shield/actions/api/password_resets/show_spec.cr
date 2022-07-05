require "../../../../spec_helper"

describe Shield::Api::PasswordResets::Show do
  it "shows password reset" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    password_reset = PasswordResetFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::PasswordResets::Show.with(
      password_reset_id: password_reset.id
    ))

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::PasswordResets::Show.with(
      password_reset_id: 5
    ))

    response.should send_json(401, logged_in: false)
  end
end
