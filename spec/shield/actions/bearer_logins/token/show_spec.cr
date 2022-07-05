require "../../../../spec_helper"

describe Shield::BearerLogins::Token::Show do
  it "renders show page" do
    password = "password4APASSWORD<"
    token = "123.a1b2c3"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    session = Lucky::Session.new
    BearerTokenSession.new(session).set(token)

    client = ApiClient.new
    client.browser_auth(user, password, session: session)

    response = client.exec(BearerLogins::Token::Show)

    response.body.should eq("BearerLogins::Token::ShowPage:#{token}")
  end

  it "requires logged in" do
    response = ApiClient.exec(BearerLogins::Token::Show)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
