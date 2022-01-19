module Shield::LoginsEverywhere::Delete
  macro included
    include Shield::LoginsEverywhere::Destroy

    # delete "/login/all" do
    #   run_operation
    # end

    def run_operation
      DeleteLoginsEverywhere.update(
        login,
        skip_current: true
      ) do |operation, updated_login|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_login)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
