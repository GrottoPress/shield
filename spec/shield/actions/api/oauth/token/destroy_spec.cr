require "../../../../../spec_helper"

describe Shield::Api::Oauth::Token::Destroy do
  it "revokes access token" do
    token = "a1b2c3"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)
      .token(token)

    bearer_login.status.active?.should be_true

    access_token = BearerLoginCredentials.new(token, bearer_login.id)

    client = ApiClient.new

    response = client.exec(
      Api::Oauth::Token::Destroy,
      token: access_token,
      client_id: oauth_client.id
    )

    response.should send_json(200, {success: true})
    bearer_login.reload.status.active?.should be_false
  end

  it "verifies secret for confidential OAuth clients" do
    token = "a1b2c3"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")

    oauth_client = OauthClientFactory.create &.user_id(developer.id)
      .secret("abc123")

    bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)
      .oauth_client_id(oauth_client.id)
      .token(token)

    access_token = BearerLoginCredentials.new(token, bearer_login.id)

    client = ApiClient.new

    response = client.exec(
      Api::Oauth::Token::Destroy,
      token: access_token,
      client_id: oauth_client.id
    )

    response.should send_json(
      401,
      error: "invalid_client",
      error_description: "action.pipe.oauth.client_auth_failed"
    )
  end
end
