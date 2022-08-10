require "../../../../spec_helper"

describe Shield::OauthClients::Users::Index do
  it "renders index page" do
    password = "password4APASSWORD<"

    developer = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(developer.id)
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    client = ApiClient.new
    client.browser_auth(developer, password)

    response = client.exec(OauthClients::Users::Index.with(
      oauth_client_id: oauth_client.id
    ))

    response.body.should eq("OauthClients::Users::IndexPage")
  end

  it "requires logged in" do
    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    response = ApiClient.exec(OauthClients::Users::Index.with(
      oauth_client_id: oauth_client.id
    ))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
