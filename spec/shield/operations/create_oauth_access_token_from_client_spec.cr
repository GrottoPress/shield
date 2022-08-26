require "../../spec_helper"

describe Shield::CreateOauthAccessTokenFromClient do
  it "creates OAuth access token" do
    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)\

    CreateOauthAccessTokenFromClient.create(
      oauth_client: oauth_client,
      scopes: [BearerScope.new(Api::CurrentUser::Show).to_s]
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login.try do |_bearer_login|
        _bearer_login.status.active?.should be_true
        _bearer_login.inactive_at.should_not be_nil
      end

      operation.token.should_not be_empty
    end
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
