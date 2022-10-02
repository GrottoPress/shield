# Token Introspection endpoint
# See https://datatracker.ietf.org/doc/html/rfc7662
#
# NOTE: This is for *Shield* login tokens. If doing OAuth,
#       use `Shield::Api::Oauth::Token::Verify` instead
module Shield::Api::Logins::Token::Verify
  macro included
    skip :require_logged_out
    skip :check_authorization

    # post "/logins/token/verify" do
    #   run_operation
    # end

    def run_operation
      LoginParams.new(params).verify do |utility, login|
        if login
          do_verify_operation_succeeded(utility, login.not_nil!)
        else
          do_verify_operation_failed(utility)
        end
      end
    end

    def do_verify_operation_succeeded(utility, login)
      json({
        active: true,
        exp: login.inactive_at.try(&.to_unix),
        iat: login.active_at.to_unix,
        iss: Lucky::RouteHelper.settings.base_uri,
        jti: login.id.to_s,
        sub: login.user_id.to_s,
        token_type: "Bearer",
      })
    end

    def do_verify_operation_failed(utility)
      json({active: false})
    end
  end
end
