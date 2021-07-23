module Shield::Logins::Delete
  macro included
    include Shield::Logins::Destroy

    # delete "/logins/:login_id" do
    #   run_operation
    # end

    def run_operation
      DeleteLogin.delete(login) do |operation, deleted_login|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_login.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
