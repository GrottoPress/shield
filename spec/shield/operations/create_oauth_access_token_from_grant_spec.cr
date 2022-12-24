require "../../spec_helper"

describe Shield::CreateOauthAccessTokenFromGrant do
  context "Authorization Code grant" do
    it "creates OAuth access token" do
      scopes = [
        BearerScope.new(Api::Posts::Index).to_s,
        BearerScope.new(Api::CurrentUser::Show).to_s
      ]

      developer = UserFactory.create
      resource_owner = UserFactory.create &.email("resource@owner.com")
      UserOptionsFactory.create &.user_id(resource_owner.id)
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .type(OauthGrantType::AUTHORIZATION_CODE)
        .scopes(scopes)

      oauth_grant.status.active?.should be_true

      CreateOauthAccessTokenFromGrant.create(
        oauth_grant: oauth_grant,
        scopes: [BearerScope.new(Api::CurrentUser::Show).to_s]
      ) do |operation, bearer_login|
        bearer_login.should be_a(BearerLogin)

        bearer_login.try do |_bearer_login|
          _bearer_login.status.active?.should be_true
          _bearer_login.inactive_at.should_not be_nil
          _bearer_login.scopes.should eq(scopes)
          _bearer_login.name.should eq("operation.misc.oauth.access_token_name")
        end

        operation.token.should_not be_empty
        operation.credentials.should_not be_nil
      end

      oauth_grant.reload.status.success?.should be_true
    end
  end

  context "Refresh Token grant" do
    it "creates OAuth access token" do
      scopes = [BearerScope.new(Api::CurrentUser::Show).to_s]

      developer = UserFactory.create
      resource_owner = UserFactory.create &.email("resource@owner.com")
      UserOptionsFactory.create &.user_id(resource_owner.id)
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .type(OauthGrantType::REFRESH_TOKEN)
        .scopes([
          BearerScope.new(Api::CurrentUser::Show).to_s,
          BearerScope.new(Api::Posts::Index).to_s
        ])

      oauth_grant.status.active?.should be_true

      CreateOauthAccessTokenFromGrant.create(
        oauth_grant: oauth_grant,
        scopes: scopes
      ) do |operation, bearer_login|
        bearer_login.should be_a(BearerLogin)

        bearer_login.try do |_bearer_login|
          _bearer_login.status.active?.should be_true
          _bearer_login.inactive_at.should_not be_nil
          _bearer_login.scopes.should eq(scopes)
          _bearer_login.name.should eq("operation.misc.oauth.access_token_name")
        end

        operation.token.should_not be_empty
        operation.credentials.should_not be_nil
      end

      oauth_grant.reload
        .status
        .success?(Shield.settings.oauth_refresh_token_grace.from_now)
        .should(be_true)
    end
  end

  it "requires active OAuth grant" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_grant =
      OauthGrantFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .inactive_at(Time.utc)
        .type(OauthGrantType::REFRESH_TOKEN)

    CreateOauthAccessTokenFromGrant.create(
      oauth_grant: oauth_grant
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      operation.oauth_client_id
        .should(have_error "operation.error.oauth.client_id_required")
    end
  end

  it "revokes access tokens if OAuth grant replayed" do
    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_grant =
      OauthGrantFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .inactive_at(Time.utc)
        .type(OauthGrantType::REFRESH_TOKEN)

    bearer_login = BearerLoginFactory.create &.user_id(developer.id)

    BearerLoginFactory.create_pair &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    CreateOauthAccessTokenFromGrant.create(
      oauth_grant: oauth_grant
    ) do |_, _bearer_login|
      _bearer_login.should be_nil
    end

    BearerLoginQuery.new
      .oauth_client_id(oauth_client.id)
      .is_active
      .any? # ameba:disable Performance/AnyInsteadOfEmpty
      .should(be_false)

    # ameba:disable Performance/AnyInsteadOfEmpty
    BearerLoginQuery.new.id(bearer_login.id).any?.should be_true
  end
end
