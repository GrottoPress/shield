require "../../spec_helper"

describe Shield::CreateOauthAccessTokenFromAuthorization do
  it "creates OAuth access token" do
    oauth_grant_type = OauthGrantType.new(OauthGrantType::AUTHORIZATION_CODE)

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    UserOptionsFactory.create &.user_id(resource_owner.id)
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_authorization =
      OauthAuthorizationFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)

    oauth_authorization.status.active?.should be_true

    CreateOauthAccessTokenFromAuthorization.create(
      oauth_authorization: oauth_authorization,
      oauth_grant_type: oauth_grant_type
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login.try do |_bearer_login|
        _bearer_login.status.active?.should be_true
        _bearer_login.inactive_at.should_not be_nil
      end

      operation.token.should_not be_empty
      operation.refresh_token.should_not be_nil
    end

    oauth_authorization.reload.status.success?.should be_true
  end

  it "requires active OAuth authorization" do
    oauth_grant_type = OauthGrantType.new(OauthGrantType::REFRESH_TOKEN)

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_authorization =
      OauthAuthorizationFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .inactive_at(Time.utc)

    CreateOauthAccessTokenFromAuthorization.create(
      oauth_authorization: oauth_authorization,
      oauth_grant_type: oauth_grant_type
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      operation.oauth_client_id
        .should(have_error "operation.error.oauth_client_id_required")
    end
  end

  it "revokes access tokens if OAuth authorization replayed" do
    oauth_grant_type = OauthGrantType.new(OauthGrantType::REFRESH_TOKEN)

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_authorization =
      OauthAuthorizationFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .inactive_at(Time.utc)

    bearer_login = BearerLoginFactory.create &.user_id(developer.id)

    BearerLoginFactory.create_pair &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)

    CreateOauthAccessTokenFromAuthorization.create(
      oauth_authorization: oauth_authorization,
      oauth_grant_type: oauth_grant_type
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
