require "../../../spec_helper"

describe Shield::OauthClients::Edit do
  it "renders edit page" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    oauth_client = OauthClientFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(OauthClients::Edit.with(
      oauth_client_id: oauth_client.id
    ))

    response.body.should eq("OauthClients::EditPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(OauthClients::Edit.with(oauth_client_id: 22))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
