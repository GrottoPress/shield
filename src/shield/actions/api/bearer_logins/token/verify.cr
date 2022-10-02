# Token Introspection endpoint
# See https://datatracker.ietf.org/doc/html/rfc7662
#
# NOTE: This is for user-generated bearer tokens. If doing OAuth,
#       use `Shield::Api::Oauth::Token::Verify` instead
module Shield::Api::BearerLogins::Token::Verify
  macro included
    skip :require_logged_out
    skip :check_authorization

    # post "/bearer-logins/token/verify" do
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

    private def scope
      params.get?(:scope)
    end
  end
end
