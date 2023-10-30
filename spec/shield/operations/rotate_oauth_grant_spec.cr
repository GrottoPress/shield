require "../../spec_helper"

describe Shield::RotateOauthGrant do
  it "rotates OAuth grant" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)
      .type(OauthGrantType.authorization_code)

    RotateOauthGrant.update(
      oauth_grant,
      success: false
    ) do |operation, _|
      operation.saved?.should be_true
      operation.credentials.should_not be_nil
    end

    oauth_grant.reload.status.failure?.should be_true
  end

  it "requires active OAuth grant" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_grant =
      OauthGrantFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .inactive_at(Time.utc)
        .type(OauthGrantType::REFRESH_TOKEN)

    RotateOauthGrant.update(oauth_grant) do |operation, _|
      operation.saved?.should be_false

      operation.inactive_at
        .should(have_error "operation.error.oauth.grant_inactive")
    end
  end
end
