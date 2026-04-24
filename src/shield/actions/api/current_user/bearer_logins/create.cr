module Shield::Api::CurrentUser::BearerLogins::Create
  macro included
    skip :require_logged_out

    authorize_user do |user|
      user.id == self.user.id
    end

    # post "/account/bearer-logins" do
    #   run_operation
    # end

    def run_operation
      CreateBearerLogin.create(
        params,
        user: user
      ) do |operation, bearer_login|
        if operation.saved?
          do_run_operation_succeeded(operation, bearer_login.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def user
      current_user
    end

    def do_run_operation_succeeded(operation, bearer_login)
      json BearerLoginSerializer.new(
        bearer_login: bearer_login,
        token: BearerLoginCredentials.new(operation, bearer_login).to_s,
        message: Rex.t(:"action.current_user.bearer_login.create.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.current_user.bearer_login.create.failure")
      )
    end
  end
end
