require "../../../spec_helper"

class Spec::Oauth::Pipes < ApiAction
  include Shield::Api::Oauth::Token::Pipes

  skip :require_logged_in
  skip :require_logged_out
  skip :pin_login_to_ip_address
  skip :check_authorization

  before :oauth_validate_client_id
  # before :oauth_handle_errors
  before :oauth_check_duplicate_params
  before :oauth_validate_scope

  param client_id : String?
  param code_challenge : String?
  param code_challenge_method : String = "plain"
  param redirect_uri : String?
  param response_type : String?
  param scope : String?
  param state : String?

  get "/spec/api/oauth/pipes" do
    raise "Server error"
  end

  def scopes : Array(String)
    scope.try(&.split) || Array(String).new
  end
end

describe Shield::Oauth::Pipes do
  pending "#oauth_handle_errors" do
    it "handles server errors" do
      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      response = ApiClient.exec(
        Spec::Oauth::Pipes,
        client_id: oauth_client.id,
        code_challenge: "a1b2c3",
        redirect_uri: oauth_client.redirect_uris.first?,
        response_type: "code",
        scope: "api.current_user.show",
        state: "abc123"
      )

      response.should send_json(
        500,
        error: "server_error",
        error_description: "action.pipe.oauth.server_error"
      )
    end
  end

  describe "#oauth_check_duplicate_params" do
    it "rejects requests with duplicated params" do
      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      response = ApiClient.get "#{Spec::Oauth::Pipes.path}?\
        client_id=#{oauth_client.id}&\
        client_id=23&\
        code_challenge=a1b2c3&\
        redirect_uri=#{oauth_client.redirect_uris.first?}&\
        response_type=code&\
        scope=api.current_user.show&\
        state=abc123"

      response.should send_json(
        400,
        error: "invalid_request",
        error_description: "action.pipe.oauth.duplicate_params"
      )
    end
  end

  describe "#oauth_validate_client_id" do
    it "validates client ID" do
      response = ApiClient.exec(
        Spec::Oauth::Pipes,
        client_id: 23,
        code_challenge: "a1b2c3",
        redirect_uri: "myapp://callback",
        response_type: "code",
        scope: "api.current_user.show",
        state: "abc123"
      )

      response.should send_json(
        400,
        error: "invalid_client",
        error_description: "action.pipe.oauth.client_id_invalid"
      )
    end
  end

  describe "#oauth_validate_scope" do
    it "ensures scopes are valid" do
      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      response = ApiClient.exec(
        Spec::Oauth::Pipes,
        client_id: oauth_client.id,
        code_challenge: "a1b2c3",
        redirect_uri: oauth_client.redirect_uris.first?,
        response_type: "code",
        scope: "api.invalid.scope",
        state: "abc123"
      )

      response.should send_json(
        400,
        error: "invalid_scope",
        error_description: "action.pipe.oauth.scope_invalid"
      )
    end
  end
end
