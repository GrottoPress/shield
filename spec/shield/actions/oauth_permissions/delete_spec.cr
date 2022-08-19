require "../../../spec_helper"

describe Shield::OauthPermissions::Delete do
  it "revokes OAuth permission" do
    password = "password4APASSWORD<"

    developer = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(developer.id)

    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    BearerLoginFactory.create_pair &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    client = ApiClient.new
    client.browser_auth(developer, password)

    response = client.exec(OauthPermissions::Delete.with(
      oauth_client_id: oauth_client.id,
      user_id: resource_owner.id,
    ))

    response.headers["X-User-ID"]?.should eq(resource_owner.id.to_s)

    BearerLoginQuery.new
      .oauth_client_id(oauth_client.id)
      .user_id(resource_owner.id)
      .any? # ameba:disable Performance/AnyInsteadOfEmpty
      .should(be_false)
  end

  it "requires logged in" do
    response = ApiClient.exec(OauthPermissions::Delete.with(
      oauth_client_id: 45,
      user_id: 23
    ))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
