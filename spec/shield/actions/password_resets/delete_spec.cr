require "../../../spec_helper"

describe Shield::PasswordResets::Delete do
  it "deletes password reset" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)
    password_reset = PasswordResetFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(
      PasswordResets::Delete.with(password_reset_id: password_reset.id)
    )

    response.headers["X-Password-Reset-ID"]?.should eq(password_reset.id.to_s)
  end

  it "requires logged in" do
    response = ApiClient.exec(PasswordResets::Delete.with(password_reset_id: 9))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
