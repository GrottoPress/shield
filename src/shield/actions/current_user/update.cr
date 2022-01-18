module Shield::CurrentUser::Update
  macro included
    skip :require_logged_out

    # patch "/account" do
    #   run_operation
    # end

    def run_operation
      UpdateCurrentUser.update(
        user,
        params,
        current_login: current_login?
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def user
      current_user
    end

    def do_run_operation_succeeded(operation, user)
      flash.success = Rex.t(:"action.current_user.update.success")
      redirect to: Show
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.current_user.update.failure")
      html EditPage, operation: operation
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
