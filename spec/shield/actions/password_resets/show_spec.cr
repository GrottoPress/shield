require "../../../spec_helper"

describe Shield::PasswordResets::Show do
  it "shows password reset" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    password_reset = PasswordResetFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(PasswordResets::Show.with(
      password_reset_id: password_reset.id
    ))

    response.body.should eq("PasswordResets::ShowPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(PasswordResets::Show.with(password_reset_id: 5))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
