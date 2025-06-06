require "../../../spec_helper"

class Spec::Oauth::Pipes < ApiAction
  include Shield::Api::Oauth::Token::Pipes

  skip :pin_login_to_ip_address

  before :oauth_validate_client_id
  # before :oauth_handle_errors
  before :oauth_check_duplicate_params

  param client_id : String? = nil
  param code_challenge : String? = nil
  param code_challenge_method : String = "plain"
  param redirect_uri : String? = nil
  param response_type : String? = nil
  param scope : String? = nil
  param state : String? = nil

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

      response = ApiClient.exec(Spec::Oauth::Pipes.with(
        client_id: oauth_client.id.hexstring,
        code_challenge: "a1b2c3",
        redirect_uri: oauth_client.redirect_uris.first?,
        response_type: "code",
        scope: "api.current_user.show",
        state: "abc123"
      ))

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
      response = ApiClient.exec(Spec::Oauth::Pipes.with(
        client_id: "23",
        code_challenge: "a1b2c3",
        redirect_uri: "myapp://callback",
        response_type: "code",
        scope: "api.current_user.show",
        state: "abc123"
      ))

      response.should send_json(
        400,
        error: "invalid_client",
        error_description: "action.pipe.oauth.client_id_invalid"
      )
    end
  end
end
