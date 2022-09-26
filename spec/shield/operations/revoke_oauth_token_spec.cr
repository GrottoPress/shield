require "../../spec_helper"

describe Shield::RevokeOauthToken do
  it "requires token" do
    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    RevokeOauthToken.run(oauth_client: oauth_client) do |operation, token|
      operation.valid?.should be_false
      token.should be_nil

      operation.token.should have_error("operation.error.token_required")
    end
  end

  context "Access Token" do
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

      RevokeOauthToken.run(
        params(token: access_token),
        oauth_client: oauth_client
      ) do |operation, _token|
        operation.valid?.should be_true
        _token.should be_a(String)
      end

      bearer_login.reload.status.active?.should be_false
      bearer_login_2.reload.status.active?.should be_false
    end

    it "ensures token is an access token" do
      token = "a1b2c3"

      developer = UserFactory.create
      resource_owner = UserFactory.create &.email("resource@owner.com")
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)

      access_token = BearerLoginCredentials.new(token, bearer_login.id)

      RevokeOauthToken.run(
        params(token: access_token),
        oauth_client: oauth_client
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

      RevokeOauthToken.run(
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
end

context "Refresh Token" do
  it "revokes refresh token" do
    token = "a1b2c3"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)
      .type(OauthGrantType::REFRESH_TOKEN)
      .code(token)

    oauth_grant_2 = OauthGrantFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)
      .type(OauthGrantType::AUTHORIZATION_CODE)

    oauth_grant.status.active?.should be_true
    oauth_grant_2.status.active?.should be_true

    refresh_token = OauthGrantCredentials.new(token, oauth_grant.id)

    RevokeOauthToken.run(
      params(token: refresh_token),
      oauth_client: oauth_client
    ) do |operation, _token|
      operation.valid?.should be_true
      _token.should be_a(String)
    end

    oauth_grant.reload.status.active?.should be_false
    oauth_grant_2.reload.status.active?.should be_false
  end

  it "ensures grant type is refresh token" do
    token = "a1b2c3"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)
      .type(OauthGrantType::AUTHORIZATION_CODE)
      .code(token)

    refresh_token = OauthGrantCredentials.new(token, oauth_grant.id)

    RevokeOauthToken.run(
      params(token: refresh_token),
      oauth_client: oauth_client
    ) do |operation, _token|
      operation.valid?.should be_false
      _token.should be_nil

      operation.token
        .should(have_error "operation.error.oauth_grant_type_invalid")
    end
  end

  it "checks token was issued to the requester OAuth client" do
    token = "a1b2c3"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)
    oauth_client_2 = OauthClientFactory.create &.user_id(developer.id)

    oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client_2.id)
      .type(OauthGrantType::REFRESH_TOKEN)
      .code(token)

    refresh_token = OauthGrantCredentials.new(token, oauth_grant.id)

    RevokeOauthToken.run(
      params(token: refresh_token),
      oauth_client: oauth_client
    ) do |operation, _token|
      operation.valid?.should be_false
      _token.should be_nil

      operation.token
        .should(have_error "operation.error.oauth_client_not_authorized")
    end
  end
end
