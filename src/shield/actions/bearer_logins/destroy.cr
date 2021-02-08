module Shield::BearerLogins::Destroy
  macro included
    skip :require_logged_out

    # delete "/bearer-logins/:bearer_login_id" do
    #   run_operation
    # end

    def run_operation
      RevokeBearerLogin.update(
        bearer_login
      ) do |operation, updated_bearer_login|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_bearer_login)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, bearer_login)
      flash.success = "Bearer login revoked successfully"
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not revoke bearer login"
      redirect_back fallback: Index
    end

    @[Memoize]
    def bearer_login : BearerLogin
      BearerLoginQuery.find(bearer_login_id)
    end

    def authorize?(user : User) : Bool
      super || user.id == bearer_login.user_id
    end
  end
end
