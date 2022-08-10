require "../../spec_helper"

describe Shield::DeleteUserOauthClients do
  it "deletes OAuth clients" do
    user = UserFactory.create
    oauth_client_1 = OauthClientFactory.create &.user_id(user.id)
    oauth_client_2 = OauthClientFactory.create &.user_id(user.id)

    oauth_client_1.status.active?.should be_true
    oauth_client_2.status.active?.should be_true

    DeleteCurrentUserOauthClients.update(user) do |operation, _|
      operation.saved?.should be_true
    end

    OauthClientQuery.new.id(oauth_client_1.id).first?.should be_nil
    OauthClientQuery.new.id(oauth_client_2.id).first?.should be_nil
  end

  it "does not delete OAuth clients of other users" do
    mary_email = "mary@example.tld"
    john_email = "john@example.tld"

    mary = UserFactory.create &.email(mary_email)
    mary_oauth_client = OauthClientFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email)
    john_oauth_client = OauthClientFactory.create &.user_id(john.id)

    mary_oauth_client.status.active?.should be_true
    john_oauth_client.status.active?.should be_true

    DeleteCurrentUserOauthClients.update(mary) do |operation, _|
      operation.saved?.should be_true
    end

    OauthClientQuery.new.id(mary_oauth_client.id).first?.should be_nil

    OauthClientQuery.new
      .id(john_oauth_client.id)
      .first?
      .should(be_a OauthClient)
  end
end
