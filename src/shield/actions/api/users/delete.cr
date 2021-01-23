module Shield::Api::Users::Delete
  macro included
    include Shield::Api::Users::Destroy

    # delete "/users/:user_id" do
    #   run_operation
    # end

    def run_operation
      DeleteUser.run(
        record: user,
        current_user: current_user
      ) do |operation, deleted_user|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_user.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
