require "../../spec_helper"

describe Shield::DeactivateUserOauthClients do
  it "deactivates OAuth clients" do
    user = UserFactory.create
    oauth_client_1 = OauthClientFactory.create &.user_id(user.id)
    oauth_client_2 = OauthClientFactory.create &.user_id(user.id)

    oauth_client_1.status.active?.should be_true
    oauth_client_2.status.active?.should be_true

    DeactivateCurrentUserOauthClients.update(user) do |operation, _|
      operation.saved?.should be_true
    end

    oauth_client_1.reload.status.active?.should be_false
    oauth_client_2.reload.status.active?.should be_false
  end

  it "does not deactivate OAuth clients of other users" do
    mary_email = "mary@example.tld"
    john_email = "john@example.tld"

    mary = UserFactory.create &.email(mary_email)
    mary_oauth_client = OauthClientFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email)
    john_oauth_client = OauthClientFactory.create &.user_id(john.id)

    mary_oauth_client.status.active?.should be_true
    john_oauth_client.status.active?.should be_true

    DeactivateCurrentUserOauthClients.update(mary) do |operation, _|
      operation.saved?.should be_true
    end

    mary_oauth_client.reload.status.active?.should be_false
    john_oauth_client.reload.status.active?.should be_true
  end
end
