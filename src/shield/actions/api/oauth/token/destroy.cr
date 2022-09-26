# The Token Revocation endpoint
# See https://datatracker.ietf.org/doc/html/rfc7009
module Shield::Api::Oauth::Token::Destroy
  macro included
    include Shield::Api::Oauth::Token::Pipes

    before :oauth_validate_client_id
    before :oauth_check_multiple_client_auth
    before :oauth_validate_client_secret

    # post "/oauth/token/revoke" do
    #   run_operation
    # end

    def run_operation
      RevokeOauthToken.run(
        token: token.to_s,
        oauth_client: oauth_client
      ) do |operation, token|
        if token
          do_run_operation_succeeded(operation, token.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, token)
      json({active: false})
    end

    def do_run_operation_failed(operation)
      json({error: operation.client_authorized? ?
        "invalid_request" :
        "unauthorized_client"})
    end

    def client_id : String?
      OauthClientCredentials.from_headers?(request).try(&.id.to_s) ||
        params.get?(:client_id)
    end

    def client_secret : String?
      if OauthClientCredentials.from_headers?(request).try(&.id)
        OauthClientCredentials.from_headers?(request).try(&.password)
      else
        params.get?(:client_secret)
      end
    end

    def token : String?
      params.get?(:token)
    end
  end
end
