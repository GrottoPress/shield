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
        scopes: array_param(CreateBearerLogin, :scopes),
        allowed_scopes: BearerScope.action_scopes.map(&.name)
      ) do |operation, bearer_login|
        if bearer_login
          do_run_operation_succeeded(operation, bearer_login.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def user
      current_user!
    end

    def do_run_operation_succeeded(operation, bearer_login)
      flash.success = "Bearer login created successfully"
      flash.info = "Copy the token now; it will only be shown once!"
      html ShowPage, operation: operation, bearer_login: bearer_login
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not create bearer login"
      html NewPage, operation: operation
    end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
