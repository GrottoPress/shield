module Shield::Api::CurrentLogin::Delete
  macro included
    include Shield::Api::CurrentLogin::Destroy

    # delete "/login" do
    #   run_operation
    # end

    def run_operation
      DeleteCurrentLogin.delete(
        login,
        session: nil
      ) do |operation, deleted_login|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_login)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
