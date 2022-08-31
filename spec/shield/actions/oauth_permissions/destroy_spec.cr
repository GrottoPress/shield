require "../../../spec_helper"

describe Shield::OauthPermissions::Destroy do
  it "revokes OAuth permission" do
    password = "password4APASSWORD<"

    resource_owner = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(resource_owner.id)

    developer = UserFactory.create &.email("dev@app.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    BearerLoginFactory.create_pair &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    client = ApiClient.new
    client.browser_auth(resource_owner, password)

    response = client.exec(OauthPermissions::Destroy.with(
      oauth_client_id: oauth_client.id,
      user_id: resource_owner.id,
    ))

    response.headers["X-OAuth-Client-ID"]?.should eq(oauth_client.id.to_s)

    BearerLoginQuery.new
      .oauth_client_id(oauth_client.id)
      .user_id(resource_owner.id)
      .is_active
      .any? # ameba:disable Performance/AnyInsteadOfEmpty
      .should(be_false)
  end

  it "requires logged in" do
    response = ApiClient.exec(OauthPermissions::Destroy.with(
      oauth_client_id: 45,
      user_id: 23
    ))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
