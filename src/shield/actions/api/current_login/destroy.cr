module Shield::Api::CurrentLogin::Destroy
  macro included
    skip :require_logged_out

    # delete "/login" do
    #   run_operation
    # end

    def run_operation
      LogUserOut.update(login) do |operation, updated_login|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_login)
        else
          do_run_operation_failed(operation, updated_login)
        end
      end
    end

    @[Memoize]
    def login
      current_login!
    end

    def do_run_operation_succeeded(operation, login)
      json({
        status: "success",
        message: "Logged out. See ya!",
        data: {login: LoginSerializer.new(login)}
      })
    end

    def do_run_operation_failed(operation, login)
      json({
        status: "failure",
        message: "Something went wrong",
        data: {errors: operation.errors}
      })
    end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
