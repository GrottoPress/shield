require "../../../../spec_helper"

describe Shield::Oauth::Authorization::Create do
  it "grants authorization" do
    password = "password4APASSWORD<"
    redirect_uri = "http://my.app/cb"

    resource_owner = UserFactory.create &.email("resource@owner.com")
      .password(password)

    UserOptionsFactory.create &.user_id(resource_owner.id)

    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)
      .redirect_uris([redirect_uri])

    client = ApiClient.new
    client.browser_auth(resource_owner, password)

    response = client.exec(
      Oauth::Authorization::Create,
      oauth_grant: {
        granted: true,
        code_challenge: "a1b2c3",
        code_challenge_method: "plain",
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
        oauth_client_id: oauth_client.id,
        redirect_uri: redirect_uri
      }
    )

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-OAuth-Grant-ID"]?.should_not be_nil
  end

  it "requires logged in" do
    response = ApiClient.exec(
      Oauth::Authorization::Create,
      oauth_grant: {
        granted: true,
        code_challenge: "a1b2c3",
        code_challenge_method: "plain",
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
        oauth_client_id: 5,
        redirect_uri: "http://my.app/cb"
      }
    )

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
