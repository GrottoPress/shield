require "../../spec_helper"

describe Shield::EndUserOauthGrants do
  it "ends active OAuth grants" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_grant_1 = OauthGrantFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    oauth_grant_2 = OauthGrantFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    oauth_grant_1.status.active?.should be_true
    oauth_grant_2.status.active?.should be_true

    EndUserOauthGrants.update(resource_owner) do |operation, _|
      operation.saved?.should be_true
    end

    oauth_grant_1.reload.status.active?.should be_false
    oauth_grant_2.reload.status.active?.should be_false
  end

  it "does not end OAuth grants of other users" do
    mary_email = "mary@example.tld"
    john_email = "john@example.tld"

    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    mary = UserFactory.create &.email(mary_email)

    mary_oauth_grant = OauthGrantFactory.create &.user_id(mary.id)
      .oauth_client_id(oauth_client.id)

    john = UserFactory.create &.email(john_email)

    john_oauth_grant = OauthGrantFactory.create &.user_id(john.id)
      .oauth_client_id(oauth_client.id)

    mary_oauth_grant.status.active?.should be_true
    john_oauth_grant.status.active?.should be_true

    EndUserOauthGrants.update(mary) do |operation, _|
      operation.saved?.should be_true
    end

    mary_oauth_grant.reload.status.active?.should be_false
    john_oauth_grant.reload.status.active?.should be_true
  end
end
