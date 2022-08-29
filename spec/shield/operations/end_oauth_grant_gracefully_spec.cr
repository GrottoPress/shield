require "../../spec_helper"

describe Shield::EndOauthGrantGracefully do
  it "delays deactivation of refresh tokens" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)
      .type(:refresh_token)

    EndOauthGrantGracefully.update(
      oauth_grant,
      success: true
    ) do |operation, updated_oauth_grant|
      operation.saved?.should be_true

      updated_oauth_grant.status.active?.should be_true

      updated_oauth_grant.status
        .active?(Shield.settings.oauth_refresh_token_grace.from_now)
        .should(be_false)
    end
  end
end
