require "../../../../spec_helper"

describe Shield::Users::EmailConfirmations::Index do
  it "renders index page" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.email("nobody@domain.com")
    admin = UserFactory.create &.level(:admin).password(password)

    UserOptionsFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(admin.id)

    client = ApiClient.new
    client.browser_auth(admin, password)

    response = client.exec(Users::EmailConfirmations::Index.with(
      user_id: user.id
    ))

    response.body.should eq("Users::EmailConfirmations::IndexPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(Users::EmailConfirmations::Index.with(user_id: 4))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
