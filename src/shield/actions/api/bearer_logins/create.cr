module Shield::Api::BearerLogins::Create
  macro included
    skip :require_logged_out

    # post "/bearer-logins" do
    #   run_operation
    # end

    def run_operation
      CreateBearerLogin.create(
        params,
        user_id: user.id,
        scopes: scopes,
        all_scopes: BearerLoginHelper.all_scopes
      ) do |operation, bearer_login|
        if bearer_login
          do_run_operation_succeeded(operation, bearer_login.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def user
      current_or_bearer_user!
    end

    def do_run_operation_succeeded(operation, bearer_login)
      json({
        status: "success",
        message: "Copy the token now; it will only be shown once!",
        data: {
          bearer_login: BearerLoginSerializer.new(bearer_login),
          token: BearerLoginHelper.token(bearer_login, operation)
        }
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not create bearer login",
        data: {errors: operation.errors}
      })
    end

    def authorize?(user : User) : Bool
      user.id == current_or_bearer_user.try &.id
    end

    private def scopes : Array(String)
      array_param(CreateBearerLogin.param_key, :scopes)
    end
  end
end
