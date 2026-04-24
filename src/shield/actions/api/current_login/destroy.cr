module Shield::Api::CurrentLogin::Destroy
  macro included
    skip :require_logged_out

    authorize_user do |user|
      user.id == login.user_id
    end

    # delete "/login" do
    #   run_operation
    # end

    def run_operation
      EndCurrentLogin.update(login, session: nil) do |operation, updated_login|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_login)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def login
      current_login
    end

    def do_run_operation_succeeded(operation, login)
      json LoginSerializer.new(
        login: login,
        message: Rex.t(:"action.current_login.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.current_login.destroy.failure")
      )
    end
  end
end
