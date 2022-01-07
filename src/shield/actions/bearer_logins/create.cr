module Shield::BearerLogins::Create
  macro included
    skip :require_logged_out

    # post "/bearer-logins" do
    #   run_operation
    # end

    def run_operation
      CreateBearerLogin.create(
        params,
        user: user,
        scopes: array_param(CreateBearerLogin.param_key, :scopes),
        allowed_scopes: BearerScope.action_scopes.map(&.name)
      ) do |operation, bearer_login|
        if operation.saved?
          do_run_operation_succeeded(operation, bearer_login.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def user
      current_user
    end

    def do_run_operation_succeeded(operation, bearer_login)
      flash.success = Rex.t(:"action.bearer_login.create.success")

      html ShowPage,
        bearer_login: bearer_login,
        token: BearerToken.new(operation, bearer_login).to_s
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.bearer_login.create.failure")
      html NewPage, operation: operation
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
