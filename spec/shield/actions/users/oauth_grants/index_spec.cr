require "../../../../spec_helper"

describe Shield::Users::OauthGrants::Index do
  it "lists OAuth grants" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.email("nobody@domain.com")
    UserOptionsFactory.create &.user_id(user.id)

    admin = UserFactory.create &.level(:admin).password(password)
    UserOptionsFactory.create &.user_id(admin.id)

    client = ApiClient.new
    client.browser_auth(admin, password)

    response = client.exec(Users::OauthGrants::Index.with(
      user_id: user.id
    ))

    response.body.should eq("Users::OauthGrants::IndexPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(Users::OauthGrants::Index.with(
      user_id: 6
    ))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
