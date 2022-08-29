require "../../spec_helper"

describe Shield::DeactivateOauthClient do
  it "deactivates OAuth client" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    BearerLoginFactory.create_pair &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    OauthGrantFactory.create_pair &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    DeactivateOauthClient.update(
      oauth_client
    ) do |operation, updated_oauth_client|
      operation.saved?.should be_true
      updated_oauth_client.status.inactive?.should be_true
    end

    BearerLoginQuery.new
      .oauth_client_id(oauth_client.id)
      .is_active
      .any? # ameba:disable Performance/AnyInsteadOfEmpty
      .should(be_false)

    OauthGrantQuery.new
      .oauth_client_id(oauth_client.id)
      .is_active
      .any? # ameba:disable Performance/AnyInsteadOfEmpty
      .should(be_false)
  end
end
