require "../../../spec_helper"

describe Shield::OauthClients::Update do
  it "updates OAuth client" do
    password = "password4APASSWORD<"
    new_name = "New Client"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)
    oauth_client = OauthClientFactory.create &.user_id(user.id).name("Client")

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(
      OauthClients::Update.with(oauth_client_id: oauth_client.id),
      oauth_client: {name: new_name}
    )

    response.headers["X-OAuth-Client-ID"]?.should eq(oauth_client.id.to_s)

    oauth_client.reload.name.should eq(new_name)
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
