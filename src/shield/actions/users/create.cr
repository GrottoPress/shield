module Shield::Users::Create
  macro included
    skip :require_logged_out

    # post "/users" do
    #   run_operation
    # end

    def run_operation
      RegisterUser.create(params) do |operation, user|
        if user
          do_run_operation_succeeded(operation, user.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      flash.success = Rex.t(:"action.user.create.success")
      redirect to: Show.with(user_id: user.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.user.create.failure")
      html NewPage, operation: operation
    end
  end
end
