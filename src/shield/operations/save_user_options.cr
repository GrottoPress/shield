module Shield::SaveUserOptions # UserOptions::SaveOperation
  macro included
    permit_columns :password_notify

    before_save do
      validate_user_id_required
      validate_password_notify_required
    end

    include Lucille::ValidateUserExists

    {% if Avram::Model.all_subclasses.any?(&.name.== :BearerLogin.id) %}
      include Shield::SaveBearerLoginUserOptions
    {% end %}

    {% if Avram::Model.all_subclasses.any?(&.name.== :Login.id) %}
      include Shield::SaveLoginUserOptions
    {% end %}

    {% if Avram::Model.all_subclasses.any?(&.name.== :OauthClient.id) %}
      include Shield::SaveOauthClientUserOptions
    {% end %}

    private def validate_password_notify_required
      validate_required password_notify,
        message: Rex.t(:"operation.error.password_notify_required")
    end

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end
  end
end
