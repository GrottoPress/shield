module Shield::Api::CurrentLogin::Delete
  macro included
    include Shield::Api::Logins::Destroy

    # delete "/login" do
    #   run_operation
    # end

    def run_operation
      DeleteLogin.submit(login_id: login.id) do |operation, deleted_login|
        if deleted_login
          do_run_operation_succeeded(operation, deleted_login.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end