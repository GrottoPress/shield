require "../../../spec_helper"

describe Shield::OauthClients::Update do
  it "updates OAuth client" do
    password = "password4APASSWORD<"
    new_name = "New Client"
    new_redirect_uri = "http://localhost:10000"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    oauth_client = OauthClientFactory.create &.user_id(user.id).name("Client")
      .redirect_uris(["myapp://callback"])

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(
      OauthClients::Update.with(oauth_client_id: oauth_client.id),
      oauth_client: {name: new_name, redirect_uris: [new_redirect_uri]}
    )

    response.headers["X-OAuth-Client-ID"]?.should eq(oauth_client.id.to_s)

    oauth_client.reload.tap do |_oauth_client|
      _oauth_client.name.should eq(new_name)
      _oauth_client.redirect_uris.should eq([new_redirect_uri])
    end
  end

  it "requires logged in" do
    response = ApiClient.exec(
      OauthClients::Update.with(oauth_client_id: 22),
      oauth_client: {name: "Client"}
    )

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
