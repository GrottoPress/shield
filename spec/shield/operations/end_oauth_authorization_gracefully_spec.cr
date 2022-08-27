require "../../spec_helper"

describe Shield::EndOauthAuthorizationGracefully do
  it "delays deactivation of refresh tokens" do
    oauth_grant_type = OauthGrantType.new(OauthGrantType::REFRESH_TOKEN)

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_authorization =
      OauthAuthorizationFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)

    EndOauthAuthorizationGracefully.update(
      oauth_authorization,
      oauth_grant_type: oauth_grant_type,
      success: true
    ) do |operation, updated_oauth_authorization|
      operation.saved?.should be_true

      updated_oauth_authorization.status.active?.should be_true

      updated_oauth_authorization.status
        .active?(Shield.settings.oauth_refresh_token_grace.from_now)
        .should(be_false)
    end
  end
end
