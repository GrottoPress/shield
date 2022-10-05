require "../../spec_helper"

describe Shield::StartOauthGrant do
  context "Authorization Code Grant" do
    it "starts OAuth grant" do
      code_challenge = "a1b2c3"
      code_challenge_method = "plain"
      grant_type = OauthGrantType.new(OauthGrantType::AUTHORIZATION_CODE)
      redirect_uri = "http://localhost:5000"

      developer = UserFactory.create
      resource_owner = UserFactory.create &.email("resource@owner.com")

      oauth_client = OauthClientFactory.create &.user_id(developer.id)
        .redirect_uris([redirect_uri])

      StartOauthGrant.create(
        params(
          granted: true,
          code_challenge: code_challenge,
          code_challenge_method: code_challenge_method,
          redirect_uri: redirect_uri
        ),
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
        type: grant_type,
        oauth_client: oauth_client,
        user: resource_owner
      ) do |operation, oauth_grant|
        oauth_grant.should be_a(OauthGrant)

        oauth_grant.try do |_oauth_grant|
          _oauth_grant.pkce.should be_a(OauthGrantPkce)
          _oauth_grant.redirect_uri.should eq(redirect_uri)
          _oauth_grant.metadata.should be_a(OauthGrantMetadata)

          _oauth_grant.user_id.should eq(resource_owner.id)
          _oauth_grant.oauth_client_id.should eq(oauth_client.id)
          _oauth_grant.status.active?.should be_true
          _oauth_grant.type.should eq(grant_type)

          _oauth_grant.status
            .active?(Shield.settings.oauth_authorization_code_expiry.from_now)
            .should(be_false)
        end

        oauth_grant.try &.pkce.try do |pkce|
          pkce.challenge_method.to_s.should eq(code_challenge_method)
        end

        oauth_grant.try &.metadata.try do |metadata|
          OauthGrantPkce.new(metadata).verify?(code_challenge).should be_true
        end

        operation.code.should_not be_empty
      end
    end

    it "requires redirect URI" do
      developer = UserFactory.create
      resource_owner = UserFactory.create &.email("resource@owner.com")
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      StartOauthGrant.create(
        params(
          granted: true,
          code_challenge: "code_challenge",
          code_challenge_method: "S256",
        ),
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
        type: OauthGrantType.new(OauthGrantType::AUTHORIZATION_CODE),
        oauth_client: oauth_client,
        user: resource_owner
      ) do |operation, oauth_grant|
        oauth_grant.should be_nil

        operation.redirect_uri
          .should(have_error "operation.error.redirect_uri_required")
      end
    end
  end

  context "Client Credentials Grant" do
    it "starts OAuth grant" do
      code_challenge = "a1b2c3"
      code_challenge_method = "plain"
      grant_type = OauthGrantType.new(OauthGrantType::CLIENT_CREDENTIALS)
      redirect_uri = "http://localhost:5000"

      developer = UserFactory.create
      resource_owner = UserFactory.create &.email("resource@owner.com")

      oauth_client = OauthClientFactory.create &.user_id(developer.id)
        .redirect_uris([redirect_uri])

      StartOauthGrant.create(
        params(
          granted: true,
          code_challenge: code_challenge,
          code_challenge_method: code_challenge_method,
          redirect_uri: redirect_uri
        ),
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
        type: grant_type,
        oauth_client: oauth_client,
        user: resource_owner
      ) do |operation, oauth_grant|
        oauth_grant.should be_a(OauthGrant)

        oauth_grant.try do |_oauth_grant|
          _oauth_grant.pkce.should be_nil
          _oauth_grant.redirect_uri.should be_nil
          _oauth_grant.user_id.should eq(resource_owner.id)
          _oauth_grant.oauth_client_id.should eq(oauth_client.id)
          _oauth_grant.status.active?.should be_true
          _oauth_grant.inactive_at.should be_nil
          _oauth_grant.type.should eq(grant_type)
        end

        operation.code.should_not be_empty
      end
    end
  end

  context "Refresh Token Grant" do
    it "starts OAuth grant" do
      code_challenge = "a1b2c3"
      code_challenge_method = "plain"
      grant_type = OauthGrantType.new(OauthGrantType::REFRESH_TOKEN)
      redirect_uri = "http://localhost:5000"

      developer = UserFactory.create
      resource_owner = UserFactory.create &.email("resource@owner.com")

      oauth_client = OauthClientFactory.create &.user_id(developer.id)
        .redirect_uris([redirect_uri])

      StartOauthGrant.create(
        params(
          granted: true,
          code_challenge: code_challenge,
          code_challenge_method: code_challenge_method,
          redirect_uri: redirect_uri
        ),
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
        type: grant_type,
        oauth_client: oauth_client,
        user: resource_owner
      ) do |operation, oauth_grant|
        oauth_grant.should be_a(OauthGrant)

        oauth_grant.try do |_oauth_grant|
          _oauth_grant.pkce.should be_nil
          _oauth_grant.redirect_uri.should be_nil
          _oauth_grant.user_id.should eq(resource_owner.id)
          _oauth_grant.oauth_client_id.should eq(oauth_client.id)
          _oauth_grant.status.active?.should be_true
          _oauth_grant.inactive_at.should be_nil
          _oauth_grant.type.should eq(grant_type)
        end

        operation.code.should_not be_empty
      end
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

  it "requires registered redirect URI" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")

    oauth_client = OauthClientFactory.create &.user_id(developer.id)
      .redirect_uris(["http://localhost:5001"])

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
