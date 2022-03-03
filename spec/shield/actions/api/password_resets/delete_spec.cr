require "../../../../spec_helper"

describe Shield::Api::PasswordResets::Delete do
  it "deletes password reset" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)
    password_reset = PasswordResetFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(
      Api::PasswordResets::Delete.with(password_reset_id: password_reset.id)
    )

    response.should send_json(
      200,
      {message: "action.password_reset.destroy.success"}
    )

    # ameba:disable Performance/AnyInsteadOfEmpty
    PasswordResetQuery.new.id(password_reset.id).any?.should be_false
  end

  it "requires logged in" do
    response = ApiClient.exec(
      Api::PasswordResets::Delete.with(password_reset_id: 9)
    )

    response.should send_json(401, logged_in: false)
  end
end
