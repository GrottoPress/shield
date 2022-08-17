require "../../../../spec_helper"

describe Shield::Api::OauthPermissions::Delete do
  it "revokes OAuth permission" do
    password = "password4APASSWORD<"

    developer = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(developer.id)

    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    BearerLoginFactory.create_pair &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    client = ApiClient.new
    client.api_auth(developer, password)

    response = client.exec(Api::OauthPermissions::Delete.with(
      oauth_client_id: oauth_client.id,
      user_id: resource_owner.id,
    ))

    response.should send_json(200, {
      message: "action.oauth_permission.destroy.success"
    })

    # ameba:disable Performance/AnyInsteadOfEmpty
    BearerLoginQuery.new
      .oauth_client_id(oauth_client.id)
      .user_id(resource_owner.id)
      .any?
      .should(be_false)
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::OauthPermissions::Delete.with(
      oauth_client_id: 45,
      user_id: 23
    ))

    response.should send_json(401, logged_in: false)
  end
end
