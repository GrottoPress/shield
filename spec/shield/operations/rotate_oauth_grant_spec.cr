require "../../spec_helper"

describe Shield::RotateOauthGrant do
  it "rotates OAuth grant" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)
      .type(OauthGrantType::AUTHORIZATION_CODE)

    RotateOauthGrant.create(
      oauth_grant: oauth_grant
    ) do |operation, _oauth_grant|
      _oauth_grant.should be_a(OauthGrant)

      _oauth_grant.try do |grant|
        grant.pkce.should be_nil
        grant.user_id.should eq(resource_owner.id)
        grant.oauth_client_id.should eq(oauth_client.id)
        grant.status.active?.should be_true
        grant.type.to_s.should eq(OauthGrantType::REFRESH_TOKEN)
      end

      operation.code.should_not be_empty
    end

    oauth_grant.reload.status.success?.should be_true
  end
end
