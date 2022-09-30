module Shield::Api::Oauth::Authorization::Create
  macro included
    include Shield::Api::Oauth::Authorization::Pipes

    before :oauth_validate_redirect_uri
    # before :oauth_handle_errors
    before :oauth_check_duplicate_params
    before :oauth_require_authorization_params
    before :oauth_validate_response_type
    before :oauth_validate_client_id
    before :oauth_validate_scope
    before :oauth_require_code_challenge
    before :oauth_validate_code_challenge_method
    before :oauth_require_logged_in

    # post "/oauth/authorization" do
    #   run_operation
    # end

    def run_operation
      StartOauthGrant.create(
        code_challenge: code_challenge.to_s,
        code_challenge_method: code_challenge_method,
        granted: granted,
        redirect_uri: redirect_uri.to_s,
        response_type: response_type.to_s,
        state: state.to_s,
        scopes: scopes,
        type: OauthGrantType.new(OauthGrantType::AUTHORIZATION_CODE),
        oauth_client: oauth_client?,
        user: user
      ) do |operation, oauth_grant|
        if operation.saved?
          do_run_operation_succeeded(operation, oauth_grant.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, oauth_grant)
      code = OauthGrantCredentials.new(operation, oauth_grant)

      json({
        code: code.to_s,
        redirect_to: oauth_redirect_uri(code: code.to_s, state: state).to_s,
        state: state
      })
    end

    def do_run_operation_failed(operation)
      error = operation.granted.value ? "invalid_request" : "access_denied"

      json({
        error: error,
        redirect_to: oauth_redirect_uri(error: error, state: state).to_s,
        state: state,
      })
    end

    def user
      current_user_or_bearer
    end

    def client_id : String?
      params.get?(:client_id)
    end

    def code_challenge : String?
      params.get?(:code_challenge)
    end

    def code_challenge_method : String
      params.get?(:code_challenge_method) || OauthGrantPkce::METHOD_PLAIN
    end

    def granted : Bool
      value = Bool.adapter.parse(params.get? :granted).value
      value.nil? ? false : value
    end

    def redirect_uri : String?
      params.get?(:redirect_uri)
    end

    def response_type : String?
      params.get?(:response_type)
    end

    def scope : String?
      params.get?(:scope)
    end

    def scopes : Array(String)
      scope.try(&.split) || Array(String).new
    end

    def state : String?
      params.get?(:state)
    end
  end
end
