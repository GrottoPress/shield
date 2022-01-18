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
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, login)
      flash.success = Rex.t(:"action.login.destroy.success")
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.login.destroy.failure")
      redirect_back fallback: Index
    end

    getter login : Login do
      LoginQuery.find(login_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == login.user_id
    end
  end
end
