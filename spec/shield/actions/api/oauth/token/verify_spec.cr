require "../../../../../spec_helper"

describe Shield::Api::Oauth::Token::Verify do
  it "verifies OAuth access token" do
    scope_to_check = BearerScope.new(Api::CurrentUser::Show).to_s
    raw_login_token = "a1b2c3"
    raw_access_token = "d4e5f6"

    login_user = UserFactory.create

    login_bearer_login = BearerLoginFactory.create &.user_id(login_user.id)
      .token(raw_login_token)
      .scopes([BearerScope.new(Api::Oauth::Token::Verify).to_s])

    login_token = BearerLoginCredentials.new(
      raw_login_token,
      login_bearer_login.id
    )

    resource_owner = UserFactory.create &.email("resource@owner.com")
    UserOptionsFactory.create &.user_id(resource_owner.id)

    developer = UserFactory.create &.email("dev@app.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)
      .token(raw_access_token)
      .oauth_client_id(oauth_client.id)
      .scopes([scope_to_check])

    access_token = BearerLoginCredentials.new(
      raw_access_token,
      bearer_login.id
    )

    api_client = ApiClient.new
    api_client.api_auth(login_token)

    response = api_client.exec(
      Api::Oauth::Token::Verify,
      token: access_token,
      scope: scope_to_check
    )

    response.should send_json(200, {active: true})
  end

  it "fails if token is invalid" do
    scope_to_check = BearerScope.new(Api::CurrentUser::Show).to_s
    raw_login_token = "a1b2c3"
    raw_access_token = "d4e5f6"

    login_user = UserFactory.create

    login_bearer_login = BearerLoginFactory.create &.user_id(login_user.id)
      .token(raw_login_token)
      .scopes([BearerScope.new(Api::Oauth::Token::Verify).to_s])

    login_token = BearerLoginCredentials.new(
      raw_login_token,
      login_bearer_login.id
    )

    resource_owner = UserFactory.create &.email("resource@owner.com")
    UserOptionsFactory.create &.user_id(resource_owner.id)

    developer = UserFactory.create &.email("dev@app.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)
      .token(raw_access_token)
      .oauth_client_id(oauth_client.id)
      .scopes([scope_to_check])
      .inactive_at(Time.utc)

    access_token = BearerLoginCredentials.new(
      raw_access_token,
      bearer_login.id
    )

    api_client = ApiClient.new
    api_client.api_auth(login_token)

    response = api_client.exec(
      Api::Oauth::Token::Verify,
      token: access_token,
      scope: scope_to_check
    )

    response.should send_json(200, {active: false})
  end

  it "requires authentication" do
    scope_to_check = BearerScope.new(Api::CurrentUser::Show).to_s
    raw_access_token = "d4e5f6"

    resource_owner = UserFactory.create &.email("resource@owner.com")
    UserOptionsFactory.create &.user_id(resource_owner.id)

    developer = UserFactory.create &.email("dev@app.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)
      .token(raw_access_token)
      .oauth_client_id(oauth_client.id)
      .scopes([scope_to_check])

    access_token = BearerLoginCredentials.new(
      raw_access_token,
      bearer_login.id
    )

    response = ApiClient.exec(
      Api::Oauth::Token::Verify,
      token: access_token,
      scope: scope_to_check
    )

    response.should send_json(401, logged_in: false)
  end

  context "public clients" do
    it "rejects client credentials if presented" do
      raw_access_token = "d4e5f6"

      resource_owner = UserFactory.create &.email("resource@owner.com")
      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)
        .token(raw_access_token)
        .oauth_client_id(oauth_client.id)

      access_token = BearerLoginCredentials.new(
        raw_access_token,
        bearer_login.id
      )

      response = ApiClient.exec(
        Api::Oauth::Token::Verify,
        token: access_token,
        client_id: oauth_client.id,
        client_secret: "a1b2c3"
      )

      response.should send_json(401, logged_in: false)
    end
  end

  context "confidential clients" do
    it "accepts client credentials" do
      client_secret = "a1b2c3"
      raw_access_token = "d4e5f6"

      resource_owner = UserFactory.create &.email("resource@owner.com")
      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)
        .secret(client_secret)

      bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)
        .token(raw_access_token)
        .oauth_client_id(oauth_client.id)

      access_token = BearerLoginCredentials.new(
        raw_access_token,
        bearer_login.id
      )

      response = ApiClient.exec(
        Api::Oauth::Token::Verify,
        token: access_token,
        client_id: oauth_client.id,
        client_secret: client_secret
      )

      response.should send_json(200, {active: true})
    end

    it "accepts login credentials" do
      raw_access_token = "d4e5f6"
      raw_login_token = "a1b2c3"

      login_user = UserFactory.create

      login_bearer_login = BearerLoginFactory.create &.user_id(login_user.id)
        .token(raw_login_token)
        .scopes([BearerScope.new(Api::Oauth::Token::Verify).to_s])

      login_token = BearerLoginCredentials.new(
        raw_login_token,
        login_bearer_login.id
      )

      resource_owner = UserFactory.create &.email("resource@owner.com")
      UserOptionsFactory.create &.user_id(resource_owner.id)

      developer = UserFactory.create &.email("dev@app.com")
      oauth_client = OauthClientFactory.create &.user_id(developer.id)
        .secret("a1b2c3")

      bearer_login = BearerLoginFactory.create &.user_id(resource_owner.id)
        .token(raw_access_token)
        .oauth_client_id(oauth_client.id)

      access_token = BearerLoginCredentials.new(
        raw_access_token,
        bearer_login.id
      )

      api_client = ApiClient.new
      api_client.api_auth(login_token)

      response = api_client.exec(Api::Oauth::Token::Verify, token: access_token)

      response.should send_json(200, {active: true})
    end
  end
end
