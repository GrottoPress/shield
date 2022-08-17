require "../../spec_helper"

describe Shield::RevokeUserOauthAccessTokens do
  it "revokes access tokens" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client_1 = OauthClientFactory.create &.user_id(developer.id)
    oauth_client_2 = OauthClientFactory.create &.user_id(developer.id)

    access_token_1 = BearerLoginFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client_1.id)

    access_token_2 = BearerLoginFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client_2.id)

    access_token_1.status.active?.should be_true
    access_token_2.status.active?.should be_true

    RevokeUserOauthAccessTokens.update(resource_owner) do |operation, _|
      operation.saved?.should be_true
    end

    access_token_1.reload.status.active?.should be_false
    access_token_2.reload.status.active?.should be_false
  end

  it "does not revoke access tokens of other users" do
    mary_email = "mary@example.tld"
    john_email = "john@example.tld"

    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    mary = UserFactory.create &.email(mary_email)

    mary_access_token = BearerLoginFactory.create &.user_id(mary.id)
      .oauth_client_id(oauth_client.id)

    john = UserFactory.create &.email(john_email)

    john_access_token = BearerLoginFactory.create &.user_id(john.id)
      .oauth_client_id(oauth_client.id)

    mary_access_token.status.active?.should be_true
    john_access_token.status.active?.should be_true

    RevokeUserOauthAccessTokens.update(mary) do |operation, _|
      operation.saved?.should be_true
    end

    mary_access_token.reload.status.active?.should be_false
    john_access_token.reload.status.active?.should be_true
  end
end
