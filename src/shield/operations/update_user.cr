module Shield::UpdateUser # User::SaveOperation
  macro included
    permit_columns :email

    attribute password : String

    include Shield::SetPasswordDigestFromPassword
    include Shield::EndUserLoginsOnPasswordChange
    include Shield::ValidateUser

    {% if Avram::Model.all_subclasses.any?(&.name.== :UserOptions.id) %}
      include Shield::HasOneSaveUserOptions
      include Shield::NotifyPasswordChange
    {% elsif Lucille::JSON.includers.any?(&.name.== :UserSettings.id) %}
      include Shield::SaveUserSettings
      include Shield::NotifyPasswordChangeIfSet

      {% if Avram::Model.all_subclasses.any?(&.name.== :BearerLogin.id) %}
        include Shield::SaveBearerLoginUserSettings
      {% end %}

      {% if Avram::Model.all_subclasses.any?(&.name.== :Login.id) %}
        include Shield::SaveLoginUserSettings
      {% end %}

      {% if Avram::Model.all_subclasses.any?(&.name.== :OauthClient.id) %}
        include Shield::SaveOauthClientUserSettings
      {% end %}
    {% end %}
  end
end
