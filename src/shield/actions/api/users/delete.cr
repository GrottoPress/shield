module Shield::Api::Users::Delete
  macro included
    include Shield::Api::Users::Destroy

    # delete "/users/:user_id" do
    #   run_operation
    # end

    def run_operation
      DeleteUser.delete(
        user,
        current_user: _current_user?
      ) do |operation, deleted_user|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_user.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def _current_user?
      {% if Avram::Model.all_subclasses
        .map(&.stringify)
        .includes?("BearerLogin") %}

        current_user_or_bearer?
      {% else %}
        current_user?
      {% end %}
    end
  end
end
