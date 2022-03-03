require "../../../spec_helper"

describe Shield::PasswordResets::Index do
  it "renders index page" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password).level(:admin)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(PasswordResets::Index)

    response.body.should eq("PasswordResets::IndexPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(PasswordResets::Index)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
