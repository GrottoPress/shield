module Shield::Api::BearerLogins::Verify
  macro included
    skip :require_logged_in
    skip :require_logged_out
    skip :check_authorization

    # post "/bearer-logins/verify" do
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
      json BearerLoginSerializer.new(
        bearer_login: bearer_login,
        message: Rex.t(:"action.bearer_login.verify.success")
      )
    end

    def do_verify_operation_failed(utility)
      json FailureSerializer.new(message: Rex.t(:"action.misc.token_invalid"))
    end

    private def scope
      params.get?(:scope)
    end
  end
end
