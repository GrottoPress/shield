# The Token Introspection endpoint
# See https://datatracker.ietf.org/doc/html/rfc7662
module Shield::Api::Oauth::Token::Verify
  macro included
    include Shield::Api::Oauth::Token::Pipes

    before :oauth_require_logged_in

    # post "/oauth/token/verify" do
    #   run_operation
    # end

    def run_operation
      BearerLoginParams.new(params).verify(scope) do |utility, bearer_login|
        if bearer_login
          do_verify_operation_succeeded(utility, bearer_login.not_nil!)
        else
          do_verify_operation_failed(utility)
        end
      end
    end

    def do_verify_operation_succeeded(utility, bearer_login)
      json({
        active: true,
        client_id: bearer_login.oauth_client_id.to_s,
        exp: bearer_login.inactive_at.try(&.to_unix),
        iat: bearer_login.active_at.to_unix,
        jti: bearer_login.id.to_s,
        scope: bearer_login.scopes.join(' '),
        sub: bearer_login.user_id.to_s,
        token_type: "Bearer",
      })
    end

    def do_verify_operation_failed(utility)
      json({active: false})
    end

    def scope : String?
      params.get?(:scope)
    end
  end
end
