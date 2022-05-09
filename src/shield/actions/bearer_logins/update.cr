module Shield::BearerLogins::Update
  macro included
    skip :require_logged_out

    # patch "/bearer-logins/:bearer_login_id" do
    #   run_operation
    # end

    def run_operation
      UpdateBearerLogin.update(
        bearer_login,
        scopes: array_param(UpdateBearerLogin.param_key, :scopes),
        allowed_scopes: BearerScope.action_scopes.map(&.name)
      ) do |operation, updated_bearer_login|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_bearer_login)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, bearer_login)
      flash.success = Rex.t(:"action.bearer_login.update.success")
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.bearer_login.update.failure")
      redirect_back fallback: Index
    end

    getter bearer_login : BearerLogin do
      BearerLoginQuery.find(bearer_login_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == bearer_login.user_id
    end
  end
end
