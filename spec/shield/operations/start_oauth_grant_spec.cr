require "../../spec_helper"

describe Shield::StartOauthGrant do
  it "starts OAuth grant" do
    code_challenge = "a1b2c3"
    code_challenge_method = "plain"
    grant_type = OauthGrantType.new(OauthGrantType::AUTHORIZATION_CODE)

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    StartOauthGrant.create(
      params(
        granted: true,
        code_challenge: code_challenge,
        code_challenge_method: code_challenge_method
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
      type: grant_type,
      oauth_client: oauth_client,
      user: resource_owner
    ) do |operation, oauth_grant|
      oauth_grant.should be_a(OauthGrant)

      oauth_grant.try do |_oauth_grant|
        _oauth_grant.pkce.should be_a(OauthGrantPkce)
        _oauth_grant.user_id.should eq(resource_owner.id)
        _oauth_grant.oauth_client_id.should eq(oauth_client.id)
        _oauth_grant.status.active?.should be_true
        _oauth_grant.type.should eq(grant_type)
      end

      oauth_grant.try &.pkce.try do |pkce|
        pkce.challenge.should eq(code_challenge)
        pkce.challenge_method.to_s.should eq(code_challenge_method)
      end

      operation.code.should_not be_empty
    end
  end

  it "requires OAuth grant granted" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    StartOauthGrant.create(
      params(
        granted: false,
        code_challenge: "code_challenge",
        code_challenge_method: "S256"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
      type: OauthGrantType.new(OauthGrantType::AUTHORIZATION_CODE),
      oauth_client: oauth_client,
      user: resource_owner
    ) do |operation, oauth_grant|
      oauth_grant.should be_nil

      operation.granted
        .should(have_error "operation.error.authorization_denied")
    end
  end

  it "requires correct redirect URI" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")

    oauth_client = OauthClientFactory.create &.user_id(developer.id)
      .redirect_uri("http://localhost:5001")

    StartOauthGrant.create(
      params(
        granted: true,
        code_challenge: "code_challenge",
        code_challenge_method: "S256",
        redirect_uri: "myapp://callback"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
      type: OauthGrantType.new(OauthGrantType::AUTHORIZATION_CODE),
      oauth_client: oauth_client,
      user: resource_owner
    ) do |operation, oauth_grant|
      oauth_grant.should be_nil

      operation.redirect_uri
        .should(have_error "operation.error.redirect_uri_invalid")
    end
  end

  it "requires valid response type" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    StartOauthGrant.create(
      params(
        granted: false,
        code_challenge: "code_challenge",
        code_challenge_method: "S256",
        response_type: "token"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
      type: OauthGrantType.new(OauthGrantType::AUTHORIZATION_CODE),
      oauth_client: oauth_client,
      user: resource_owner
    ) do |operation, oauth_grant|
      oauth_grant.should be_nil

      operation.response_type
        .should(have_error "operation.error.response_type_invalid")
    end
  end
end
