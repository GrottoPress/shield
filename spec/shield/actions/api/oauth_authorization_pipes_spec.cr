require "../../../spec_helper"

class Spec::Api::OauthAuthorizationPipes < ApiAction
  include Shield::Api::OauthAuthorizationPipes

  skip :require_logged_in
  skip :require_logged_out
  skip :pin_login_to_ip_address
  skip :check_authorization

  before :oauth_validate_client_id
  before :oauth_require_params
  before :oauth_validate_response_type
  before :oauth_require_code_challenge
  before :oauth_validate_code_challenge_method

  param client_id : String?
  param code_challenge : String?
  param code_challenge_method : String = "plain"
  param redirect_uri : String?
  param response_type : String?
  param scope : String?
  param state : String?

  get "/spec/api/oauth/authorization/pipes" do
    json({success: true})
  end

  def scopes : Array(String)
    scope.try(&.split) || Array(String).new
  end
end

describe Shield::Api::OauthAuthorizationPipes do
  describe "#oauth_validate_client_id" do
    it "validates client ID" do
      response = ApiClient.exec(
        Spec::Api::OauthAuthorizationPipes,
        client_id: 23,
        code_challenge: "a1b2c3",
        redirect_uri: "myapp://callback",
        response_type: "code",
        scope: "api.current_user.show",
        state: "abc123"
      )

      response.should send_json(
        400,
        error: "invalid_request",
        error_description: "action.pipe.oauth.client_id_invalid"
      )
    end
  end

  describe "#oauth_require_params" do
    it "requires response type" do
      resource_owner = UserFactory.create &.email("resource@owner.com")
      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      response = ApiClient.exec(
        Spec::Api::OauthAuthorizationPipes,
        client_id: oauth_client.id,
        code_challenge: "a1b2c3",
        redirect_uri: oauth_client.redirect_uri,
        scope: "api.current_user.show",
        state: "abc123"
      )

      response.should send_json(
        400,
        error: "invalid_request",
        error_description: "action.pipe.oauth.params_missing"
      )
    end

    it "requires scope" do
      resource_owner = UserFactory.create &.email("resource@owner.com")
      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      response = ApiClient.exec(
        Spec::Api::OauthAuthorizationPipes,
        client_id: oauth_client.id,
        code_challenge: "a1b2c3",
        redirect_uri: oauth_client.redirect_uri,
        response_type: "code",
        state: "abc123"
      )

      response.should send_json(
        400,
        error: "invalid_request",
        error_description: "action.pipe.oauth.params_missing"
      )
    end

    it "requires state" do
      resource_owner = UserFactory.create &.email("resource@owner.com")
      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      response = ApiClient.exec(
        Spec::Api::OauthAuthorizationPipes,
        client_id: oauth_client.id,
        code_challenge: "a1b2c3",
        redirect_uri: oauth_client.redirect_uri,
        response_type: "code",
        scope: "api.current_user.show"
      )

      response.should send_json(
        400,
        error: "invalid_request",
        error_description: "action.pipe.oauth.params_missing"
      )
    end
  end

  describe "#oauth_validate_response_type" do
    it "ensures response type is valid" do
      resource_owner = UserFactory.create &.email("resource@owner.com")
      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      response = ApiClient.exec(
        Spec::Api::OauthAuthorizationPipes,
        client_id: oauth_client.id,
        code_challenge: "a1b2c3",
        redirect_uri: oauth_client.redirect_uri,
        response_type: "token",
        scope: "api.current_user.show",
        state: "abc123"
      )

      response.should send_json(
        400,
        error: "unsupported_response_type",
        error_description: "action.pipe.oauth.response_type_invalid"
      )
    end
  end

  describe "#oauth_require_code_challenge" do
    it "requires code challenge" do
      resource_owner = UserFactory.create &.email("resource@owner.com")
      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      response = ApiClient.exec(
        Spec::Api::OauthAuthorizationPipes,
        client_id: oauth_client.id,
        redirect_uri: oauth_client.redirect_uri,
        response_type: "code",
        scope: "api.current_user.show",
        state: "abc123"
      )

      response.should send_json(
        400,
        error: "invalid_request",
        error_description: "action.pipe.oauth.code_challenge_required"
      )
    end
  end

  describe "#oauth_validate_code_challenge_method" do
    it "ensures code challenge method is valid" do
      resource_owner = UserFactory.create &.email("resource@owner.com")
      developer = UserFactory.create
      oauth_client = OauthClientFactory.create &.user_id(developer.id)

      response = ApiClient.exec(
        Spec::Api::OauthAuthorizationPipes,
        client_id: oauth_client.id,
        code_challenge: "a1b2c3",
        code_challenge_method: "S512",
        redirect_uri: oauth_client.redirect_uri,
        response_type: "code",
        scope: "api.current_user.show",
        state: "abc123"
      )

      response.should send_json(
        400,
        error: "invalid_request",
        error_description: "action.pipe.oauth.code_challenge_method_invalid"
      )
    end
  end
end
