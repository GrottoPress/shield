require "../../spec_helper"

describe Shield::RotateOauthClientSecret do
  it "refreshes OAuth client secret" do
    secret = "a1b2c3"

    user = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(user.id).secret(secret)

    RotateOauthClientSecret.update(
      oauth_client
    ) do |operation, updated_oauth_client|
      operation.saved?.should be_true
      operation.secret.should_not be_empty

      updated_oauth_client.secret_digest.should_not be_nil

      updated_oauth_client.secret_digest.try do |digest|
        Sha256Hash.new(secret).verify?(digest).should be_false
      end
    end
  end

  it "requires confidential OAuth client" do
    user = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(user.id)

    RotateOauthClientSecret.update(oauth_client) do |operation, _|
      operation.saved?.should be_false
      operation.secret.should_not be_empty

      operation.secret_digest
        .should(have_error "operation.error.oauth.client_public")
    end
  end

  it "ensures OAuth client is active" do
    user = UserFactory.create

    oauth_client = OauthClientFactory.create &.user_id(user.id)
      .inactive_at(Time.utc)

    RotateOauthClientSecret.update(oauth_client) do |operation, _|
      operation.saved?.should be_false
      operation.id.should have_error("operation.error.oauth.client_inactive")
    end
  end
end
