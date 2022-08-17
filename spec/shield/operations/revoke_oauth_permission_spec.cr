require "../../spec_helper"

describe Shield::RevokeOauthPermission do
  it "revokes OAuth permission" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    access_token = BearerLoginFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)

    access_token.status.active?.should be_true
    bearer_login.status.active?.should be_true

    RevokeOauthPermission.update(
      resource_owner,
      oauth_client: oauth_client
    ) do |operation, _|
      operation.saved?.should be_true
    end

    access_token.reload.status.active?.should be_false
    bearer_login.reload.status.active?.should be_true
  end
end
