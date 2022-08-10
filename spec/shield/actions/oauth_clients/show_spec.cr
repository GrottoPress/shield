require "../../../spec_helper"

describe Shield::OauthClients::Show do
  it "renders show page" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    oauth_client = OauthClientFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(OauthClients::Show.with(
      oauth_client_id: oauth_client.id
    ))

    response.body.should eq("OauthClients::ShowPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(OauthClients::Show.with(oauth_client_id: 5))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
