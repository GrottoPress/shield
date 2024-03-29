# The Token Introspection endpoint
# See https://datatracker.ietf.org/doc/html/rfc7662
#
# NOTE:
#  *Shield* does not support refresh token introspection. It may
#   be added in the future, if a good use case comes up.
module Shield::Api::Oauth::Token::Verify
  macro included
    include Shield::Api::Oauth::Token::Pipes

    before :oauth_maybe_require_logged_in

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
        iss: Lucky::RouteHelper.settings.base_uri,
        jti: bearer_login.id.to_s,
        scope: bearer_login.scopes.join(' '),
        sub: bearer_login.user_id.to_s,
        token_type: "Bearer",
      })
    end

    def do_verify_operation_failed(utility)
      json({active: false})
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

    def scope : String?
      params.get?(:scope)
    end
  end
end
