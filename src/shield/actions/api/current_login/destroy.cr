module Shield::Api::CurrentLogin::Destroy
  macro included
    skip :require_logged_out

    # delete "/login" do
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

    def login
      current_login
    end

    def do_run_operation_succeeded(operation, login)
      json({
        status: "success",
        message: "You logged out",
        data: {login: LoginSerializer.new(login)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Something went wrong",
        data: {errors: operation.errors}
      })
    end

    def authorize?(user : Shield::User) : Bool
      user.id == login.user_id
    end
  end
end
