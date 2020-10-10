module Shield::Logins::Destroy
  macro included
    skip :require_logged_out

    # delete "/logins/:login_id" do
    #   run_operation
    # end

    def run_operation
      LogUserOut.update(login, session: session) do |operation, updated_login|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_login)
        else
          do_run_operation_failed(operation, updated_login)
        end
      end
    end

    def login
      LoginQuery.find(login_id)
    end

    def do_run_operation_succeeded(operation, login)
      flash.keep.success = "Login revoked successfully"
      redirect to: Index
    end

    def do_run_operation_failed(operation, login)
      flash.keep.failure = "Could not revoke login"
      redirect_back fallback: Index
    end

    def authorize?(user : User) : Bool
      super || user.id == login.user_id
    end
  end
end
