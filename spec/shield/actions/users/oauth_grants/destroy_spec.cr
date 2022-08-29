require "../../../../spec_helper"

describe Shield::Users::OauthGrants::Destroy do
  it "deactivates OAuth grants" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.email("nobody@domain.com")
    UserOptionsFactory.create &.user_id(user.id)

    admin = UserFactory.create &.level(:admin).password(password)
    UserOptionsFactory.create &.user_id(admin.id)

    client = ApiClient.new
    client.browser_auth(admin, password)

    response = client.exec(Users::OauthGrants::Destroy.with(
      user_id: user.id
    ))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-User-ID"]?.should_not be_nil
  end

  it "requires logged in" do
    response = ApiClient.exec(Users::OauthGrants::Destroy.with(
      user_id: 6
    ))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
