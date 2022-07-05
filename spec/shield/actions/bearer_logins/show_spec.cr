require "../../../spec_helper"

describe Shield::BearerLogins::Show do
  it "renders show page" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    bearer_login = BearerLoginFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(BearerLogins::Show.with(
      bearer_login_id: bearer_login.id
    ))

    response.body.should eq("BearerLogins::ShowPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(BearerLogins::Show.with(bearer_login_id: 5))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
