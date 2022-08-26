require "../../../../../spec_helper"

describe Shield::Api::Oauth::Token::Create do
  context "Authorization Code grant" do
    it "creates OAuth access token" do
      code = "a1b2c3"
      client_secret = "def456"
      code_challenge = "abc123"

      pkce = OauthAuthorizationPkce.from_json({
        code_challenge: code_challenge,
        code_challenge_method: "plain"
      }.to_json)

      developer = UserFactory.create
      resource_owner = UserFactory.create &.email("resource@owner.com")
      UserOptionsFactory.create &.user_id(resource_owner.id)

      oauth_client = OauthClientFactory.create &.user_id(developer.id)
        .secret(client_secret)

      oauth_authorization =
        OauthAuthorizationFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code(code)
          .pkce(pkce)

      code_final = OauthAuthorizationCredentials.new(
        code,
        oauth_authorization.id
      ).to_s

      response = ApiClient.exec(
        Api::Oauth::Token::Create,
        client_id: oauth_client.id,
        code: code_final,
        redirect_uri: oauth_client.redirect_uri,
        grant_type: "authorization_code",
        code_verifier: code_challenge,
        client_secret: client_secret
      )

      response.should send_json(200, {token_type: "Bearer"})
    end
  end

  context "Client Credentials grant" do
    it "creates OAuth access token" do
      client_secret = "def456"

      developer = UserFactory.create
      resource_owner = UserFactory.create &.email("resource@owner.com")
      UserOptionsFactory.create &.user_id(resource_owner.id)

      oauth_client = OauthClientFactory.create &.user_id(developer.id)
        .secret(client_secret)

      response = ApiClient.exec(
        Api::Oauth::Token::Create,
        client_id: oauth_client.id,
        redirect_uri: oauth_client.redirect_uri,
        grant_type: "client_credentials",
        client_secret: client_secret,
        scope: "api.current_user.show"
      )

      response.should send_json(200, {token_type: "Bearer"})
    end
  end
end
