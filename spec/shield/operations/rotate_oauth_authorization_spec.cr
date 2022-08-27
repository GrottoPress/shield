require "../../spec_helper"

describe Shield::RotateOauthAuthorization do
  it "rotates OAuth authorization" do
    oauth_grant_type = OauthGrantType.new(OauthGrantType::REFRESH_TOKEN)

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_authorization =
      OauthAuthorizationFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)

    RotateOauthAuthorization.create(
      oauth_authorization: oauth_authorization,
      oauth_grant_type: oauth_grant_type
    ) do |operation, _oauth_authorization|
      _oauth_authorization.should be_a(OauthAuthorization)

      _oauth_authorization.try do |authorization|
        authorization.pkce.should be_nil
        authorization.user_id.should eq(resource_owner.id)
        authorization.oauth_client_id.should eq(oauth_client.id)
        authorization.status.active?.should be_true
      end

      operation.code.should_not be_empty
    end

    oauth_authorization.reload.tap do |authorization|
      authorization.status.success?.should be_false

      authorization.status
        .success?(Shield.settings.oauth_refresh_token_grace.from_now)
        .should(be_true)
    end
  end
end
