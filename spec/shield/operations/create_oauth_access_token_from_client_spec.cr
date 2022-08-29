require "../../spec_helper"

describe Shield::CreateOauthAccessTokenFromClient do
  it "creates OAuth access token" do
    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    CreateOauthAccessTokenFromClient.create(
      oauth_client: OauthClientQuery.preload_user(oauth_client),
      scopes: [BearerScope.new(Api::CurrentUser::Show).to_s]
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login.try do |_bearer_login|
        _bearer_login.status.active?.should be_true
        _bearer_login.inactive_at.should_not be_nil
      end

      operation.token.should_not be_empty
    end

    OauthGrantQuery.new
      .oauth_client_id(oauth_client.id)
      .user_id(oauth_client.user_id)
      .any? # ameba:disable Performance/AnyInsteadOfEmpty
      .should(be_true)
  end

  it "requires active OAuth client" do
    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)
      .inactive_at(Time.utc)

    CreateOauthAccessTokenFromClient.create(
      oauth_client: oauth_client,
      scopes: [BearerScope.new(Api::CurrentUser::Show).to_s]
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      operation.oauth_client_id
        .should(have_error "operation.error.oauth_client_id_required")
    end
  end
end
