require "../../spec_helper"

describe Shield::DeleteOauthPermission do
  it "deletes OAuth permission" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    access_token = BearerLoginFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)

    OauthGrantFactory.create_pair &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    DeleteOauthPermission.update(
      oauth_client,
      user: resource_owner
    ) do |operation, _|
      operation.saved?.should be_true
    end

    # ameba:disable Performance/AnyInsteadOfEmpty
    BearerLoginQuery.new.id(access_token.id).any?.should be_false
    # ameba:disable Performance/AnyInsteadOfEmpty
    BearerLoginQuery.new.id(bearer_login.id).any?.should be_true

    OauthGrantQuery.new
      .user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)
      .any? # ameba:disable Performance/AnyInsteadOfEmpty
      .should(be_false)
  end
end
