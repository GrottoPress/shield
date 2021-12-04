module Shield::Api::Logins::Destroy
  macro included
    skip :require_logged_out

    # delete "/logins/:login_id" do
    #   run_operation
    # end

    def run_operation
      LogUserOut.update(login, session: nil) do |operation, updated_login|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_login)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, login)
      json({
        status: "success",
        message: Rex.t(:"action.login.destroy.success"),
        data: {login: LoginSerializer.new(login)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.login.destroy.failure"),
        data: {errors: operation.errors}
      })
    end

    getter login : Login do
      LoginQuery.find(login_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == login.user_id
    end
  end
end
