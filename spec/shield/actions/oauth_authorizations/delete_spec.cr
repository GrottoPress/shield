require "../../../spec_helper"

describe Shield::OauthAuthorizations::Delete do
  it "deletes OAuth authorization" do
    password = "password4APASSWORD<"

    resource_owner = UserFactory.create &.email("resource@owner.com")
      .password(password)

    UserOptionsFactory.create &.user_id(resource_owner.id)

    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_authorization =
      OauthAuthorizationFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)

    client = ApiClient.new
    client.browser_auth(resource_owner, password)

    response = client.exec(OauthAuthorizations::Delete.with(
      oauth_authorization_id: oauth_authorization.id
    ))

    response.headers["X-OAuth-Authorization-ID"]?
      .should(eq oauth_authorization.id.to_s)
  end

  it "requires logged in" do
    response = ApiClient.exec(OauthAuthorizations::Delete.with(
      oauth_authorization_id: 45
    ))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
