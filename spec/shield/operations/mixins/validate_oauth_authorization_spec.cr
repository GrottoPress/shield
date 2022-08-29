require "../../../spec_helper"

private class SaveOauthAuthorization < OauthAuthorization::SaveOperation
  permit_columns :oauth_client_id,
    :user_id,
    :active_at,
    :code_digest,
    :inactive_at,
    :success

  include Shield::ValidateOauthAuthorization
end

describe Shield::ValidateOauthAuthorization do
  it "ensures scopes are unique" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveOauthAuthorization.create(
      params(
        oauth_client_id: oauth_client.id,
        user_id: resource_owner.id,
        active_at: Time.utc,
        code_digest: "a1b2c3",
        success: false,
      ),
      pkce: OauthAuthorizationPkce.from_json({
        code_challenge: "a1b2c3",
        code_challenge_method: "plain"
      }.to_json),
      scopes: [
        BearerScope.new(Api::Posts::Index).to_s,
        BearerScope.new(Api::Posts::New).to_s,
        BearerScope.new(Api::Posts::Index).to_s
      ]
    ) do |_, oauth_authorization|
      oauth_authorization.should be_a(OauthAuthorization)

      # ameba:disable Lint/ShadowingOuterLocalVar
      oauth_authorization.try do |oauth_authorization|
        oauth_authorization.scopes.should eq([
          BearerScope.new(Api::Posts::Index).to_s,
          BearerScope.new(Api::Posts::New).to_s
        ])
      end
    end
  end

  it "requires scopes" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveOauthAuthorization.create(params(
      oauth_client_id: oauth_client.id,
      user_id: resource_owner.id,
      active_at: Time.utc,
      code_digest: "a1b2c3",
      success: false,
    )) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.scopes
        .should have_error("operation.error.bearer_scopes_required")
    end
  end

  it "requires user ID" do
    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveOauthAuthorization.create(
      params(
        oauth_client_id: oauth_client.id,
        active_at: Time.utc,
        code_digest: "a1b2c3",
        success: false,
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.user_id.should have_error("operation.error.user_id_required")
    end
  end

  it "requires OAuth client ID" do
    resource_owner = UserFactory.create

    SaveOauthAuthorization.create(
      params(
        user_id: resource_owner.id,
        active_at: Time.utc,
        code_digest: "a1b2c3",
        success: false,
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.oauth_client_id
        .should(have_error "operation.error.oauth_client_id_required")
    end
  end

  it "requires valid code challenge method" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveOauthAuthorization.create(
      params(
        oauth_client_id: oauth_client.id,
        user_id: resource_owner.id,
        active_at: Time.utc,
        code_digest: "a1b2c3",
        success: false,
      ),
      pkce: OauthAuthorizationPkce.from_json({
        code_challenge: "a1b2c3",
        code_challenge_method: "S512"
      }.to_json),
      scopes: [BearerScope.new(Api::Posts::Index).to_s]
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.pkce
        .should(have_error "operation.error.code_challenge_method_invalid")
    end
  end

  it "ensures user exists" do
    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveOauthAuthorization.create(
      params(
        oauth_client_id: oauth_client.id,
        user_id: 22,
        active_at: Time.utc,
        code_digest: "a1b2c3",
        success: false,
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.user_id.should have_error("operation.error.user_not_found")
    end
  end

  it "ensures OAuth client exists" do
    resource_owner = UserFactory.create

    SaveOauthAuthorization.create(
      params(
        oauth_client_id: UUID.random.to_s,
        user_id: resource_owner.id,
        active_at: Time.utc,
        code_digest: "a1b2c3",
        success: false,
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.oauth_client_id
        .should(have_error "operation.error.oauth_client_not_found")
    end
  end

  it "requires scopes not empty" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveOauthAuthorization.create(
      params(
        oauth_client_id: oauth_client.id,
        user_id: resource_owner.id,
        active_at: Time.utc,
        code_digest: "a1b2c3",
        success: false,
      ),
      scopes: Array(String).new,
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.scopes.should have_error("operation.error.bearer_scopes_empty")
    end
  end

  it "requires valid scopes" do
    Shield.temp_config(oauth_access_token_scopes_allowed: [
      BearerScope.new(Api::Posts::New).to_s,
      BearerScope.new(Api::CurrentUser::Show).to_s
    ]) do
      developer = UserFactory.create
      resource_owner = UserFactory.create &.email("resource@owner.com")
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      SaveOauthAuthorization.create(
        params(
          oauth_client_id: oauth_client.id,
          user_id: resource_owner.id,
          active_at: Time.utc,
          code_digest: "a1b2c3",
          success: false,
        ),
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
      ) do |operation, oauth_authorization|
        oauth_authorization.should be_nil

        operation.scopes
          .should have_error("operation.error.bearer_scopes_invalid")
      end
    end
  end

  it "requires code digest" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveOauthAuthorization.create(
      params(
        oauth_client_id: oauth_client.id,
        user_id: resource_owner.id,
        active_at: Time.utc,
        success: false,
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.code_digest
        .should(have_error "operation.error.auth_code_required")
    end
  end

  it "requires code challenge for public clients" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveOauthAuthorization.create(
      params(
        oauth_client_id: oauth_client.id,
        user_id: resource_owner.id,
        active_at: Time.utc,
        code_digest: "a1b2c3",
        success: false,
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, oauth_authorization|
      oauth_authorization.should be_nil

      operation.pkce.should(have_error "operation.error.pkce_required")
    end
  end

  it "does not require code challenge for confidential clients" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")

    oauth_client = OauthClientFactory.create &.user_id(developer.id)
      .secret("a1b2c3")

    SaveOauthAuthorization.create(
      params(
        oauth_client_id: oauth_client.id,
        user_id: resource_owner.id,
        active_at: Time.utc,
        code_digest: "a1b2c3",
        success: false,
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |_, oauth_authorization|
      oauth_authorization.should be_a(OauthAuthorization)
    end
  end
end
