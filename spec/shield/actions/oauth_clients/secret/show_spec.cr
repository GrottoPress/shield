require "../../../../spec_helper"

describe Shield::OauthClients::Secret::Show do
  it "renders show page" do
    password = "password4APASSWORD<"
    secret = "a1b2c3"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)
    oauth_client = OauthClientFactory.create &.user_id(user.id)

    session = Lucky::Session.new
    OauthClientSession.new(session).set(secret, oauth_client.id)

    client = ApiClient.new
    client.browser_auth(user, password, session: session)

    response = client.exec(OauthClients::Secret::Show)

    response.body.should eq("#{secret}:#{oauth_client.id}")
  end

  it "requires logged in" do
    response = ApiClient.exec(OauthClients::Secret::Show)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
