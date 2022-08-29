require "../../../spec_helper"

describe Shield::OauthGrants::Show do
  it "renders show page" do
    password = "password4APASSWORD<"

    resource_owner = UserFactory.create &.email("resource@owner.com")
      .password(password)

    UserOptionsFactory.create &.user_id(resource_owner.id)

    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    client = ApiClient.new
    client.browser_auth(resource_owner, password)

    response = client.exec(OauthGrants::Show.with(
      oauth_grant_id: oauth_grant.id
    ))

    response.body.should eq("OauthGrants::ShowPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(OauthGrants::Show.with(
      oauth_grant_id: 45
    ))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
