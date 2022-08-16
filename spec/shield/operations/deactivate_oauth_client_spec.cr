require "../../spec_helper"

describe Shield::DeactivateOauthClient do
  it "deactivates OAuth client" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    BearerLoginFactory.create_pair &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    OauthAuthorizationFactory.create_pair &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    DeactivateOauthClient.update(
      oauth_client
    ) do |operation, updated_oauth_client|
      operation.saved?.should be_true
      updated_oauth_client.status.inactive?.should be_true
    end

    # ameba:disable Performance/AnyInsteadOfEmpty
    BearerLoginQuery.new
      .oauth_client_id(oauth_client.id)
      .is_active
      .any?
      .should(be_false)

    # ameba:disable Performance/AnyInsteadOfEmpty
    OauthAuthorizationQuery.new
      .oauth_client_id(oauth_client.id)
      .is_active
      .any?
      .should(be_false)
  end
end
