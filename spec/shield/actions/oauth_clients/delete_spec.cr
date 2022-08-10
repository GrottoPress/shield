require "../../../spec_helper"

describe Shield::OauthClients::Delete do
  it "deletes OAuth client" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)
    oauth_client = OauthClientFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(OauthClients::Delete.with(
      oauth_client_id: oauth_client.id
    ))

    response.headers["X-OAuth-Client-ID"]?.should eq(oauth_client.id.to_s)
  end

  it "requires logged in" do
    response = ApiClient.exec(OauthClients::Delete.with(oauth_client_id: 45))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
