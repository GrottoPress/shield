require "../../../../spec_helper"

describe Shield::Api::EmailConfirmations::Destroy do
  it "ends email confirmation" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)
    email_confirmation = EmailConfirmationFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::EmailConfirmations::Destroy.with(
      email_confirmation_id: email_confirmation.id
    ))

    response.should send_json(
      200,
      {message: "action.email_confirmation.destroy.success"}
    )

    email_confirmation.reload.status.inactive?.should be_true
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::EmailConfirmations::Destroy.with(
      email_confirmation_id: 9
    ))

    response.should send_json(401, logged_in: false)
  end
end
