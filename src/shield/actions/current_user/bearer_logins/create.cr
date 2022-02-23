module Shield::CurrentUser::BearerLogins::Create
  macro included
    skip :require_logged_out

    # post "/account/bearer-logins" do
    #   run_operation
    # end

    def run_operation
      CreateCurrentUserBearerLogin.create(
        params,
        user: user,
        scopes: array_param(CreateCurrentUserBearerLogin.param_key, :scopes),
        allowed_scopes: BearerScope.action_scopes.map(&.name)
      ) do |operation, bearer_login|
        if operation.saved?
          BearerTokenSession.new(session).set(operation, bearer_login.not_nil!)
          do_run_operation_succeeded(operation, bearer_login.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, bearer_login)
      flash.success = Rex.t(:"action.current_user.bearer_login.create.success")
      redirect to: ::BearerLogins::Show.with(bearer_login_id: bearer_login.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.current_user.bearer_login.create.failure")
      html NewPage, operation: operation
    end

    def user
      current_user
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
