require "../../../../../spec_helper"

class Spec::Api::Oauth::Token::Pipes < ApiAction
  include Shield::Api::Oauth::Token::Pipes

  skip :require_logged_in
  skip :require_logged_out
  skip :pin_login_to_ip_address
  skip :check_authorization

  before :oauth_validate_client_id
  before :oauth_require_access_token_params
  before :oauth_validate_grant_type
  before :oauth_validate_code
  before :oauth_validate_code_verifier
  before :oauth_check_multiple_client_auth
  before :oauth_require_confidential_client
  before :oauth_validate_client_secret

  post "/spec/api/oauth/token/pipes" do
    json({success: true})
  end

  def grant_type : String?
    params.get?(:grant_type)
  end

  def code : String?
    params.get?(:code)
  end

  def redirect_uri : String?
    params.get?(:redirect_uri)
  end

  def code_verifier : String?
    params.get?(:code_verifier)
  end

  def client_id : String?
    params.get?(:client_id)
  end

  def client_secret : String?
    params.get?(:client_secret)
  end
end

describe Shield::Api::Oauth::Token::Pipes do
  context "Authorization Code Grant" do
    describe "#oauth_validate_client_id" do
      it "validates client ID" do
        code = "a1b2c3"
        code_challenge = "abc123"
        client_secret = "def456"

        pkce = OauthAuthorizationPkce.from_json({
          code_challenge: code_challenge,
          code_challenge_method: "plain"
        }.to_json)

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

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
          Spec::Api::Oauth::Token::Pipes,
          client_id: 23,
          code: code_final,
          redirect_uri: oauth_client.redirect_uri,
          grant_type: "authorization_code",
          code_verifier: code_challenge,
          client_secret: client_secret
        )

        response.should send_json(
          400,
          error: "invalid_client",
          error_description: "action.pipe.oauth.client_id_invalid"
        )
      end
    end

    describe "#oauth_require_access_token_params" do
      it "requires grant type" do
        code = "a1b2c3"
        code_challenge = "abc123"
        client_secret = "def456"

        pkce = OauthAuthorizationPkce.from_json({
          code_challenge: code_challenge,
          code_challenge_method: "plain"
        }.to_json)

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_client.redirect_uri,
          code_verifier: code_challenge,
          client_secret: client_secret
        )

        response.should send_json(
          400,
          error: "invalid_request",
          error_description: "action.pipe.oauth.params_missing"
        )
      end

      it "requires code" do
        client_secret = "def456"

        developer = UserFactory.create

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          redirect_uri: oauth_client.redirect_uri,
          grant_type: "authorization_code",
          code_verifier: "abc123",
          client_secret: client_secret
        )

        response.should send_json(
          400,
          error: "invalid_request",
          error_description: "action.pipe.oauth.params_missing"
        )
      end
    end

    describe "#oauth_validate_grant_type" do
      it "validates grant type" do
        code = "a1b2c3"
        code_challenge = "abc123"
        client_secret = "def456"

        pkce = OauthAuthorizationPkce.from_json({
          code_challenge: code_challenge,
          code_challenge_method: "plain"
        }.to_json)

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_client.redirect_uri,
          grant_type: "unsupported",
          code_verifier: code_challenge,
          client_secret: client_secret
        )

        response.should send_json(
          400,
          error: "unsupported_grant_type",
          error_description: "action.pipe.oauth.grant_type_invalid"
        )
      end
    end

    describe "#oauth_validate_code" do
      it "verifies authorization code" do
        code_challenge = "abc123"
        client_secret = "def456"

        pkce = OauthAuthorizationPkce.from_json({
          code_challenge: code_challenge,
          code_challenge_method: "plain"
        }.to_json)

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_authorization =
          OauthAuthorizationFactory.create &.user_id(resource_owner.id)
            .oauth_client_id(oauth_client.id)
            .code("a1b2c3")
            .pkce(pkce)

        code_final = OauthAuthorizationCredentials.new(
          "wrong-code",
          oauth_authorization.id
        ).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_client.redirect_uri,
          grant_type: "authorization_code",
          code_verifier: code_challenge,
          client_secret: client_secret
        )

        response.should send_json(
          400,
          error: "invalid_grant",
          error_description: "action.pipe.oauth.auth_code_invalid"
        )
      end

      it "ensures code belongs to client" do
        code = "a1b2c3"
        code_challenge = "abc123"
        client_secret = "def456"

        pkce = OauthAuthorizationPkce.from_json({
          code_challenge: code_challenge,
          code_challenge_method: "plain"
        }.to_json)

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_client_2 = OauthClientFactory.create &.user_id(developer.id)
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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client_2.id,
          code: code_final,
          redirect_uri: oauth_client.redirect_uri,
          grant_type: "authorization_code",
          code_verifier: "2j6k3n",
          client_secret: client_secret
        )

        response.should send_json(
          400,
          error: "invalid_grant",
          error_description: "action.pipe.oauth.auth_code_invalid"
        )
      end
    end

    describe "#oauth_validate_code_verifier" do
      it "requires valid code verifier for public clients" do
        code = "a1b2c3"
        code_challenge = "abc123"

        pkce = OauthAuthorizationPkce.from_json({
          code_challenge: code_challenge,
          code_challenge_method: "plain"
        }.to_json)

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)

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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_client.redirect_uri,
          grant_type: "authorization_code",
          code_verifier: "2j6k3n",
        )

        response.should send_json(
          400,
          error: "invalid_grant",
          error_description: "action.pipe.oauth.code_verifier_invalid"
        )
      end

      it "does not require code verifier for confidential clients" do
        code = "a1b2c3"
        client_secret = "def456"

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_authorization =
          OauthAuthorizationFactory.create &.user_id(resource_owner.id)
            .oauth_client_id(oauth_client.id)
            .code(code)

        code_final = OauthAuthorizationCredentials.new(
          code,
          oauth_authorization.id
        ).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_client.redirect_uri,
          grant_type: "authorization_code",
          client_secret: client_secret
        )

        response.should send_json(200, success: true)
      end

      it "validates code verifier for confidential clients" do
        code = "a1b2c3"
        client_secret = "def456"

        pkce = OauthAuthorizationPkce.from_json({
          code_challenge: "abc123",
          code_challenge_method: "plain"
        }.to_json)

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_client.redirect_uri,
          grant_type: "authorization_code",
          client_secret: client_secret,
        )

        response.should send_json(
          400,
          error: "invalid_grant",
          error_description: "action.pipe.oauth.code_verifier_invalid"
        )
      end
    end

    describe "#oauth_validate_client_secret" do
      it "verifies client secret" do
        code = "a1b2c3"
        code_challenge = "abc123"

        pkce = OauthAuthorizationPkce.from_json({
          code_challenge: code_challenge,
          code_challenge_method: "plain"
        }.to_json)

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret("def456")

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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_client.redirect_uri,
          grant_type: "authorization_code",
          code_verifier: code_challenge,
          client_secret: "wrong-secret"
        )

        response.should send_json(
          401,
          error: "invalid_client",
          error_description: "action.pipe.oauth.client_auth_failed"
        )

        response.headers["WWW-Authenticate"]?.should_not be_nil
      end

      it "skips public clients" do
        code = "a1b2c3"
        code_challenge = "abc123"

        pkce = OauthAuthorizationPkce.from_json({
          code_challenge: code_challenge,
          code_challenge_method: "plain"
        }.to_json)

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")
        oauth_client = OauthClientFactory.create &.user_id(developer.id)

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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_client.redirect_uri,
          grant_type: "authorization_code",
          code_verifier: code_challenge,
        )

        response.should send_json(200, success: true)
      end
    end

    describe "#oauth_check_multiple_client_auth" do
      it "rejects multiple client authentication mechanisms" do
        code = "a1b2c3"
        client_secret = "def456"

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_authorization =
          OauthAuthorizationFactory.create &.user_id(resource_owner.id)
            .oauth_client_id(oauth_client.id)
            .code(code)

        api_client = ApiClient.new

        api_client.basic_auth OauthClientCredentials.new(
          client_secret,
          oauth_client.id
        )

        response = api_client.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: OauthAuthorizationCredentials.new(
            code,
            oauth_authorization.id
          ).to_s,
          redirect_uri: oauth_client.redirect_uri,
          grant_type: "authorization_code",
          client_secret: client_secret
        )

        response.should send_json(
          400,
          error: "invalid_request",
          error_description: "action.pipe.oauth.multiple_client_auth"
        )
      end
    end
  end

  context "Client Credentials Grant" do
    describe "#oauth_validate_client_id" do
      it "validates client ID" do
        client_secret = "def456"

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")
        UserOptionsFactory.create &.user_id(resource_owner.id)

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        response = ApiClient.exec(
          Api::Oauth::Token::Create,
          client_id: 23,
          redirect_uri: oauth_client.redirect_uri,
          client_secret: client_secret,
          grant_type: "client_credentials",
          scope: "api.current_user.show"
        )

        response.should send_json(
          400,
          error: "invalid_client",
          error_description: "action.pipe.oauth.client_id_invalid"
        )
      end
    end

    describe "#oauth_require_access_token_params" do
      it "requires grant type" do
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
          client_secret: client_secret,
          scope: "api.current_user.show"
        )

        response.should send_json(
          400,
          error: "invalid_request",
          error_description: "action.pipe.oauth.params_missing"
        )
      end
    end

    describe "#oauth_validate_grant_type" do
      it "validates grant type" do
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
          client_secret: client_secret,
          grant_type: "unsupported",
          scope: "api.current_user.show"
        )

        response.should send_json(
          400,
          error: "unsupported_grant_type",
          error_description: "action.pipe.oauth.grant_type_invalid"
        )
      end
    end

    describe "#oauth_validate_client_secret" do
      it "verifies client secret" do
        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")
        UserOptionsFactory.create &.user_id(resource_owner.id)

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret("a1b2c3")

        response = ApiClient.exec(
          Api::Oauth::Token::Create,
          client_id: oauth_client.id,
          redirect_uri: oauth_client.redirect_uri,
          client_secret: "abcdef",
          grant_type: "client_credentials",
          scope: "api.current_user.show"
        )

        response.should send_json(
          401,
          error: "invalid_client",
          error_description: "action.pipe.oauth.client_auth_failed"
        )
      end
    end

    describe "#oauth_check_multiple_client_auth" do
      it "rejects multiple client authentication mechanisms" do
        client_secret = "def456"

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")
        UserOptionsFactory.create &.user_id(resource_owner.id)

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        api_client = ApiClient.new

        api_client.basic_auth OauthClientCredentials.new(
          client_secret,
          oauth_client.id
        )

        response = api_client.exec(
          Api::Oauth::Token::Create,
          client_id: oauth_client.id,
          redirect_uri: oauth_client.redirect_uri,
          client_secret: client_secret,
          grant_type: "client_credentials",
          scope: "api.current_user.show"
        )

        response.should send_json(
          400,
          error: "invalid_request",
          error_description: "action.pipe.oauth.multiple_client_auth"
        )
      end
    end

    describe "#oauth_require_confidential_client" do
      it "requires OAuth client is confidential" do
        resource_owner = UserFactory.create &.email("resource@owner.com")
        UserOptionsFactory.create &.user_id(resource_owner.id)

        developer = UserFactory.create
        oauth_client = OauthClientFactory.create &.user_id(developer.id)

        response = ApiClient.exec(
          Api::Oauth::Token::Create,
          client_id: oauth_client.id,
          redirect_uri: oauth_client.redirect_uri,
          client_secret: "a1b2c3",
          grant_type: "client_credentials",
          scope: "api.current_user.show"
        )

        response.should send_json(
          400,
          error: "invalid_client",
          error_description: "action.pipe.oauth.client_public"
        )
      end
    end
  end
end
