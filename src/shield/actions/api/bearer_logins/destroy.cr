module Shield::Api::BearerLogins::Destroy
  macro included
    skip :require_logged_out

    # delete "/bearer-logins/:bearer_login_id" do
    #   run_operation
    # end

    def run_operation
      RevokeBearerLogin.update(
        bearer_login
      ) do |operation, updated_bearer_login|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_bearer_login)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, bearer_login)
      json BearerLoginSerializer.new(
        bearer_login: bearer_login,
        message: Rex.t(:"action.bearer_login.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.bearer_login.destroy.failure")
      )
    end

    getter bearer_login : BearerLogin do
      {% if Avram::Model.all_subclasses.any?(&.name.== :OauthClient.id) %}
        BearerLoginQuery.new.preload_oauth_client.find(bearer_login_id)
      {% else %}
        BearerLoginQuery.find(bearer_login_id)
      {% end %}
    end

    def authorize?(user : Shield::User) : Bool
      {% if Avram::Model.all_subclasses.any?(&.name.== :OauthClient.id) %}
        super ||
          user.id == bearer_login.user_id ||
          user.id == bearer_login.oauth_client.try(&.user_id)
      {% else %}
        super || user.id == bearer_login.user_id
      {% end %}
    end
  end
end
