require "../../../../../spec_helper"

describe Shield::Api::Oauth::Token::Verify do
  it "verifies OAuth access token" do
    scope = BearerScope.new(Api::CurrentUser::Show).to_s
    client_secret = "a1b2c3"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    UserOptionsFactory.create &.user_id(resource_owner.id)

    oauth_client = OauthClientFactory.create &.user_id(developer.id)
      .secret(client_secret)

    oauth_authorization =
      OauthAuthorizationFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .scopes([scope])

    CreateOauthAccessToken.create(
      oauth_authorization
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login.try do |_bearer_login|
        token = BearerLoginCredentials.new(operation, _bearer_login)

        client = ApiClient.new

        client.basic_auth OauthClientCredentials.new(
          client_secret,
          oauth_client.id
        )

        response = client.exec(
          Api::Oauth::Token::Verify,
          token: token,
          scope: scope
        )

        response.should send_json(200, {active: true})
      end
    end
  end

  it "fails if token is invalid" do
    scope = BearerScope.new(Api::CurrentUser::Show).to_s
    client_secret = "a1b2c3"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    UserOptionsFactory.create &.user_id(resource_owner.id)

    oauth_client = OauthClientFactory.create &.user_id(developer.id)
      .secret(client_secret)

    oauth_authorization =
      OauthAuthorizationFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .scopes([scope])

    token = BearerLoginCredentials.new("abcdef", 2)

    client = ApiClient.new

    client.basic_auth OauthClientCredentials.new(
      client_secret,
      oauth_client.id
    )

    response = client.exec(
      Api::Oauth::Token::Verify,
      token: token,
      scope: scope
    )

    response.should send_json(200, {active: false})
  end

  it "fails if token was not issued to client" do
    scope = BearerScope.new(Api::CurrentUser::Show).to_s
    client_secret = "a1b2c3"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    UserOptionsFactory.create &.user_id(resource_owner.id)

    oauth_client = OauthClientFactory.create &.user_id(developer.id)
      .secret(client_secret)

    oauth_client_2 = OauthClientFactory.create &.user_id(developer.id)

    oauth_authorization =
      OauthAuthorizationFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client_2.id)
        .scopes([scope])

    CreateOauthAccessToken.create(
      oauth_authorization
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login.try do |_bearer_login|
        token = BearerLoginCredentials.new(operation, _bearer_login)

        client = ApiClient.new

        client.basic_auth OauthClientCredentials.new(
          client_secret,
          oauth_client.id
        )

        response = client.exec(
          Api::Oauth::Token::Verify,
          token: token,
          scope: scope
        )

        response.should send_json(200, {active: false})
      end
    end
  end

  it "fails if token does not have the requested scope" do
    scope = BearerScope.new(Api::CurrentUser::Show).to_s
    client_secret = "a1b2c3"

    developer = UserFactory.create
    resource_owner = UserFactory.create &.email("resource@owner.com")
    UserOptionsFactory.create &.user_id(resource_owner.id)

    oauth_client = OauthClientFactory.create &.user_id(developer.id)
      .secret(client_secret)

    oauth_authorization =
      OauthAuthorizationFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .scopes([BearerScope.new(Api::BearerLogins::Destroy).to_s])

    CreateOauthAccessToken.create(
      oauth_authorization
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login.try do |_bearer_login|
        token = BearerLoginCredentials.new(operation, _bearer_login)

        client = ApiClient.new

        client.basic_auth OauthClientCredentials.new(
          client_secret,
          oauth_client.id
        )

        response = client.exec(
          Api::Oauth::Token::Verify,
          token: token,
          scope: scope
        )

        response.should send_json(200, {active: false})
      end
    end
  end
end
