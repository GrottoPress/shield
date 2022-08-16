require "../../spec_helper"

describe Shield::StartOauthAuthorization do
  it "starts OAuth authorization" do
    code_challenge = "a1b2c3"
    code_challenge_method = "plain"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    StartOauthAuthorization.create(
      params(
        granted: true,
        code_challenge: code_challenge,
        code_challenge_method: code_challenge_method,
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
      oauth_client: oauth_client,
      user: resource_owner
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_a(OauthAuthorization)

      oauth_authorization.try do |_oauth_authorization|
        _oauth_authorization.pkce.should be_a(OauthAuthorizationPkce)
        _oauth_authorization.user_id.should eq(resource_owner.id)
        _oauth_authorization.oauth_client_id.should eq(oauth_client.id)
        _oauth_authorization.status.active?.should be_true
      end

      oauth_authorization.try &.pkce.try do |pkce|
        pkce.code_challenge.should eq(code_challenge)
        pkce.code_challenge_method.should eq(code_challenge_method)
      end

      operation.code.should_not be_empty
    end
  end

  it "requires OAuth authorization granted" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    StartOauthAuthorization.create(
      params(
        granted: false,
        code_challenge: "code_challenge",
        code_challenge_method: "S256",
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
      oauth_client: oauth_client,
      user: resource_owner
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.granted
        .should(have_error "operation.error.authorization_denied")
    end
  end

  it "requires correct redirect URI" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")

    oauth_client = OauthClientFactory.create &.user_id(developer.id)
      .redirect_uri("http://localhost:5001")

    StartOauthAuthorization.create(
      params(
        granted: true,
        code_challenge: "code_challenge",
        code_challenge_method: "S256",
        redirect_uri: "myapp://callback"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
      oauth_client: oauth_client,
      user: resource_owner
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.redirect_uri
        .should(have_error "operation.error.redirect_uri_invalid")
    end
  end

  it "requires valid response type" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    StartOauthAuthorization.create(
      params(
        granted: false,
        code_challenge: "code_challenge",
        code_challenge_method: "S256",
        response_type: "token"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
      oauth_client: oauth_client,
      user: resource_owner
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.response_type
        .should(have_error "operation.error.response_type_invalid")
    end
  end
end
