module Shield::RevokeOauthToken # Avram::Operation
  macro included
    @bearer_login : BearerLogin?

    getter? client_authorized : Bool = true

    param_key :oauth

    needs oauth_client : OauthClient

    attribute token : String

    before_run do
      set_bearer_login

      validate_token_required
      validate_client_id_required
      validate_client_authorized
    end

    def run
      revoke_oauth_permission
    end

    private def set_bearer_login
      token.value.try do |value|
        @bearer_login = BearerLoginCredentials.from_token?(value)
          .try(&.bearer_login?)
      end
    end

    private def validate_token_required
      validate_required token, message: Rex.t(:"operation.error.token_required")
    end

    private def validate_client_id_required
      @bearer_login.try do |bearer_login|
        return if bearer_login.oauth_client_id
        token.add_error Rex.t(:"operation.error.oauth.client_id_required")
      end
    end

    private def validate_client_authorized
      @bearer_login.try do |bearer_login|
        return if oauth_client.id == bearer_login.oauth_client_id

        @client_authorized = false
        token.add_error Rex.t(:"operation.error.oauth.client_not_authorized")
      end
    end

    private def revoke_oauth_permission
      @bearer_login.try do |bearer_login|
        bearer_login.oauth_client.try do |client|
          RevokeOauthPermission.update!(client, user: bearer_login.user)
        end
      end

      token.value.not_nil!
    end

    {% if Avram::Model.all_subclasses.find(&.name.== :OauthGrant.id) %}
      include Shield::RevokeOauthRefreshToken
    {% end %}
  end
end
