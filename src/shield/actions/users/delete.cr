module Shield::Users::Delete
  macro included
    include Shield::Users::Destroy

    # delete "/users/:user_id" do
    #   run_operation
    # end

    def run_operation
      DeleteUser.submit(
        user_id: user_id,
        current_user: current_user
      ) do |operation, deleted_user|
        if deleted_user
          do_run_operation_succeeded(operation, deleted_user.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
