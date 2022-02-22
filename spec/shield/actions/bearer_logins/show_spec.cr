require "../../../spec_helper"

describe Shield::BearerLogins::Show do
  it "creates bearer login" do
    password = "password4APASSWORD<"
    token = "123.a1b2c3"

    user = UserFactory.create &.password(password)
    bearer_login = BearerLoginFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    session = Lucky::Session.new
    BearerTokenSession.new(session).set(token)

    client = ApiClient.new
    client.browser_auth(user, password, session: session)

    response = client.exec(BearerLogins::Show.with(
      bearer_login_id: bearer_login.id
    ))

    response.body.should eq("BearerLogins::ShowPage:#{token}")
  end

  it "requires logged in" do
    response = ApiClient.exec(BearerLogins::Show.with(bearer_login_id: 5))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
