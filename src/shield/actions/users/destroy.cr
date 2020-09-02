module Shield::Users::Destroy
  macro included
    skip :require_logged_out

    # delete "/users/:user_id" do
    #   run_operation
    # end

    def run_operation
      UserQuery.new.id(user_id).delete
      do_run_operation_succeeded
    end

    def do_run_operation_succeeded
      flash.success = "User deleted successfully"
      redirect to: Index
    end
  end
end
