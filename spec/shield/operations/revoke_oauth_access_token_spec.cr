require "../../spec_helper"

describe Shield::RevokeOauthAccessToken do
  it "revokes access token" do
    token = "a1b2c3"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)
      .token(token)

    bearer_login_2 = BearerLoginFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    bearer_login.status.active?.should be_true
    bearer_login_2.status.active?.should be_true

    access_token = BearerLoginCredentials.new(token, bearer_login.id)

    RevokeOauthAccessToken.run(
      params(token: access_token),
      oauth_client: oauth_client
    ) do |operation, _token|
      operation.valid?.should be_true
      _token.should be_a(String)
    end

    bearer_login.reload.status.active?.should be_false
    bearer_login_2.reload.status.active?.should be_false
  end

  it "requires token" do
    RevokeOauthAccessToken.run(oauth_client: nil) do |operation, token|
      operation.valid?.should be_false
      token.should be_nil

      operation.token.should have_error("operation.error.token_required")
    end
  end

  it "ensures token is an access token" do
    raw_token = "a1b2c3"

    user = UserFactory.create
    bearer_login = BearerLoginFactory.create &.user_id(user.id)

    token = BearerLoginCredentials.new(raw_token, bearer_login.id)

    RevokeOauthAccessToken.run(
      params(token: token),
      oauth_client: nil
    ) do |operation, _token|
      operation.valid?.should be_false
      _token.should be_nil

      operation.token
        .should(have_error "operation.error.oauth_client_id_required")
    end
  end

  it "checks token was issued to the requester OAuth client" do
    token = "a1b2c3"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)
    oauth_client_2 = OauthClientFactory.create &.user_id(developer.id)

    bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client_2.id)
      .token(token)

    access_token = BearerLoginCredentials.new(token, bearer_login.id)

    RevokeOauthAccessToken.run(
      params(token: access_token),
      oauth_client: oauth_client
    ) do |operation, _token|
      operation.valid?.should be_false
      _token.should be_nil

      operation.token
        .should(have_error "operation.error.oauth_client_not_authorized")
    end
  end
end
