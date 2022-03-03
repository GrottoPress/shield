require "../../../../spec_helper"

describe Shield::Users::PasswordResets::Destroy do
  it "ends password resets" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.email("nobody@domain.com")
    admin = UserFactory.create &.level(:admin).password(password)

    UserOptionsFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(admin.id)

    client = ApiClient.new
    client.browser_auth(admin, password)

    response = client.exec(
      Users::PasswordResets::Destroy.with(user_id: user.id)
    )

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-End-Password-Resets"]?.should eq("true")
  end

  it "requires logged in" do
    response = ApiClient.exec(Users::PasswordResets::Destroy.with(user_id: 4))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
