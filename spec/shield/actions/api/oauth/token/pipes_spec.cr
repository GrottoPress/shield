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
  before :oauth_validate_redirect_uri
  before :oauth_validate_scope
  before :oauth_validate_code
  before :oauth_validate_refresh_token
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

  def refresh_token : String?
    params.get?(:refresh_token)
  end

  def scope : String?
    params.get?(:scope)
  end

  def scopes : Array(String)
    scope.try(&.split) || Array(String).new
  end
end

describe Shield::Api::Oauth::Token::Pipes do
  context "Authorization Code Grant" do
    describe "#oauth_validate_client_id" do
      it "validates client ID" do
        code = "a1b2c3"
        code_challenge = "abc123"
        client_secret = "def456"

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code(code)
          .pkce(code_challenge, "plain")

        code_final = OauthGrantCredentials.new(code, oauth_grant.id).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: 23,
          code: code_final,
          redirect_uri: oauth_grant.redirect_uri,
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

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code(code)
          .pkce(code_challenge, "plain")

        code_final = OauthGrantCredentials.new(code, oauth_grant.id).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_grant.redirect_uri,
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
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          redirect_uri: oauth_grant.redirect_uri,
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

    describe "#oauth_validate_redirect_uri" do
      it "ensures redirect URIs match" do
        code = "a1b2c3"
        code_challenge = "abc123"
        client_secret = "def456"

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .redirect_uri("https://example.com/oauth/callback")
          .code(code)
          .pkce(code_challenge, "plain")

        code_final = OauthGrantCredentials.new(code, oauth_grant.id).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: "myapp://callback",
          code_verifier: code_challenge,
          client_secret: client_secret,
          grant_type: "authorization_code"
        )

        response.should send_json(
          400,
          error: "invalid_request",
          error_description: "action.pipe.oauth.redirect_uri_invalid"
        )
      end
    end

    describe "#oauth_validate_grant_type" do
      it "validates grant type" do
        code = "a1b2c3"
        code_challenge = "abc123"
        client_secret = "def456"

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code(code)
          .pkce(code_challenge, "plain")

        code_final = OauthGrantCredentials.new(code, oauth_grant.id).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_grant.redirect_uri,
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

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code("a1b2c3")
          .pkce(code_challenge, "plain")

        code_final = OauthGrantCredentials.new("wrong", oauth_grant.id).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_grant.redirect_uri,
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

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_client_2 = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code(code)
          .pkce(code_challenge, "plain")

        code_final = OauthGrantCredentials.new(code, oauth_grant.id).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client_2.id,
          code: code_final,
          redirect_uri: oauth_grant.redirect_uri,
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

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code(code)
          .pkce(code_challenge, "plain")

        code_final = OauthGrantCredentials.new(code, oauth_grant.id).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_grant.redirect_uri,
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

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code(code)

        code_final = OauthGrantCredentials.new(code, oauth_grant.id).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_grant.redirect_uri,
          grant_type: "authorization_code",
          client_secret: client_secret
        )

        response.should send_json(200, success: true)
      end

      it "validates code verifier for confidential clients" do
        code = "a1b2c3"
        client_secret = "def456"

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code(code)
          .pkce("abc123", "plain")

        code_final = OauthGrantCredentials.new(code, oauth_grant.id).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_grant.redirect_uri,
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

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret("def456")

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code(code)
          .pkce(code_challenge, "plain")

        code_final = OauthGrantCredentials.new(code, oauth_grant.id).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_grant.redirect_uri,
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

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")
        oauth_client = OauthClientFactory.create &.user_id(developer.id)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code(code)
          .pkce(code_challenge, "plain")

        code_final = OauthGrantCredentials.new(code, oauth_grant.id).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          code: code_final,
          redirect_uri: oauth_grant.redirect_uri,
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

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
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
          code: OauthGrantCredentials.new(
            code,
            oauth_grant.id
          ).to_s,
          redirect_uri: oauth_grant.redirect_uri,
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
        OauthClientFactory.create &.user_id(developer.id).secret(client_secret)

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: 23,
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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          redirect_uri: "http://my.app/callback",
          client_secret: client_secret,
          scope: "api.current_user.show"
        )

        response.should send_json(
          400,
          error: "invalid_request",
          error_description: "action.pipe.oauth.params_missing"
        )
      end

      it "requires scope" do
        client_secret = "def456"

        developer = UserFactory.create
        resource_owner = UserFactory.create &.email("resource@owner.com")
        UserOptionsFactory.create &.user_id(resource_owner.id)

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          client_secret: client_secret,
          redirect_uri: "http://my.app/callback",
          grant_type: "authorization_code"
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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          redirect_uri: "http://my.app/callback",
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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          redirect_uri: "http://my.app/callback",
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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          redirect_uri: "http://my.app/callback",
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
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          redirect_uri: "http://my.app/callback",
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

    describe "#oauth_validate_scope" do
      it "ensures scopes are valid" do
        client_secret = "def456"

        resource_owner = UserFactory.create &.email("resource@owner.com")

        developer = UserFactory.create
        UserOptionsFactory.create &.user_id(developer.id)

        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          redirect_uri: "http://my.app/callback",
          grant_type: "client_credentials",
          client_secret: client_secret,
          scope: "api.invalid.scope"
        )

        response.should send_json(
          400,
          error: "invalid_scope",
          error_description: "action.pipe.oauth.scope_invalid"
        )
      end
    end
  end

  context "Refresh Token Grant" do
    describe "#oauth_validate_code" do
      it "verifies refresh token" do
        client_secret = "def456"

        resource_owner = UserFactory.create &.email("resource@owner.com")
        UserOptionsFactory.create &.user_id(resource_owner.id)

        developer = UserFactory.create
        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client.id)
          .code("a1b2c3")

        refresh_token_final = OauthGrantCredentials.new(
          "wrong-token",
          oauth_grant.id
        ).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          refresh_token: refresh_token_final,
          grant_type: "refresh_token",
          client_secret: client_secret
        )

        response.should send_json(
          400,
          error: "invalid_grant",
          error_description: "action.pipe.oauth.refresh_token_invalid"
        )
      end

      it "ensures token belongs to client" do
        refresh_token = "a1b2c3"
        client_secret = "def456"

        resource_owner = UserFactory.create &.email("resource@owner.com")
        UserOptionsFactory.create &.user_id(resource_owner.id)

        developer = UserFactory.create
        oauth_client = OauthClientFactory.create &.user_id(developer.id)
          .secret(client_secret)

        oauth_client_2 = OauthClientFactory.create &.user_id(developer.id)

        oauth_grant = OauthGrantFactory.create &.user_id(resource_owner.id)
          .oauth_client_id(oauth_client_2.id)
          .code(refresh_token)

        refresh_token_final = OauthGrantCredentials.new(
          refresh_token,
          oauth_grant.id
        ).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          refresh_token: refresh_token_final,
          grant_type: "refresh_token",
          client_secret: client_secret
        )

        response.should send_json(
          400,
          error: "invalid_grant",
          error_description: "action.pipe.oauth.refresh_token_invalid"
        )
      end
    end

    describe "#oauth_validate_scope" do
      it "ensures scopes are valid" do
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
          .scopes([BearerScope.new(Api::Posts::Index).to_s])
          .type(OauthGrantType::REFRESH_TOKEN)

        refresh_token_final = OauthGrantCredentials.new(
          refresh_token,
          oauth_grant.id
        ).to_s

        response = ApiClient.exec(
          Spec::Api::Oauth::Token::Pipes,
          client_id: oauth_client.id,
          client_secret: client_secret,
          refresh_token: refresh_token_final,
          grant_type: "refresh_token",
          scope: "#{BearerScope.new(Api::CurrentUser::Show)}"
        )

        response.should send_json(
          400,
          error: "invalid_scope",
          error_description: "action.pipe.oauth.scope_invalid"
        )
      end
    end
  end
end
