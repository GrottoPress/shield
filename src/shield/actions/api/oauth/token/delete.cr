# The Token Revocation endpoint
# See https://datatracker.ietf.org/doc/html/rfc7009
module Shield::Api::Oauth::Token::Delete
  macro included
    include Shield::Api::Oauth::Token::Destroy

    # post "/oauth/token/revoke" do
    #   run_operation
    # end

    def run_operation
      DeleteOauthToken.run(
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
  end
end
