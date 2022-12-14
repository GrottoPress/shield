require "../../../../../spec_helper"

describe Shield::Api::Oauth::Token::Create do
  context "Authorization Code Grant" do
    it "creates OAuth access token" do
      code = "a1b2c3"
      client_secret = "def456"
      code_challenge = "abc123"

      developer = UserFactory.create
      resource_owner = UserFactory.create &.email("resource@owner.com")
      UserOptionsFactory.create &.user_id(resource_owner.id)

      oauth_client = OauthClientFactory.create &.user_id(developer.id)
        .secret(client_secret)

      oauth_grant =
        OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code(code)
          .pkce(code_challenge, "plain")

      code_final = OauthGrantCredentials.new(
        code,
        oauth_grant.id
      ).to_s

      response = ApiClient.exec(
        Api::Oauth::Token::Create,
        client_id: oauth_client.id,
        code: code_final,
        redirect_uri: oauth_grant.redirect_uri,
        grant_type: "authorization_code",
        code_verifier: code_challenge,
        client_secret: client_secret
      )

      response.should send_json(200, {token_type: "Bearer"})
    end
  end

  context "Client Credentials Grant" do
    it "creates OAuth access token" do
      client_secret = "def456"

      developer = UserFactory.create
      UserOptionsFactory.create &.user_id(developer.id)

      oauth_client = OauthClientFactory.create &.user_id(developer.id)
        .secret(client_secret)

      response = ApiClient.exec(
        Api::Oauth::Token::Create,
        client_id: oauth_client.id,
        grant_type: "client_credentials",
        client_secret: client_secret,
        scope: "api.current_user.show"
      )

      response.should send_json(200, {token_type: "Bearer"})
    end
  end

  context "Refresh Token Grant" do
    it "creates OAuth access token" do
      refresh_token = "a1b2c3"
      client_secret = "def456"

      resource_owner = UserFactory.create &.email("resource@owner.com")
      UserOptionsFactory.create &.user_id(resource_owner.id)

      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)
        .secret(client_secret)

      oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)
        .code(refresh_token)
        .type(OauthGrantType::REFRESH_TOKEN)

      refresh_token_final = OauthGrantCredentials.new(
        refresh_token,
        oauth_grant.id
      ).to_s

      response = ApiClient.exec(
        Api::Oauth::Token::Create,
        client_id: oauth_client.id,
        refresh_token: refresh_token_final,
        grant_type: "refresh_token",
        client_secret: client_secret
      )

      response.should send_json(200, {token_type: "Bearer"})
    end
  end
end
