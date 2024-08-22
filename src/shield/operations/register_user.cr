module Shield::RegisterUser # User::SaveOperation
  macro included
    permit_columns :email

    attribute password : String

    include Shield::SetPasswordDigestFromPassword
    include Shield::ValidateUser

    {% if Avram::Model.all_subclasses.find(&.name.== :UserOptions.id) %}
      include Shield::HasOneSaveUserOptions
    {% elsif Lucille::JSON.includers.find(&.name.== :UserSettings.id) %}
      include Shield::SaveUserSettings

      {% if Avram::Model.all_subclasses.find(&.name.== :BearerLogin.id) %}
        include Shield::SaveBearerLoginUserSettings
      {% end %}

      {% if Avram::Model.all_subclasses.find(&.name.== :Login.id) %}
        include Shield::SaveLoginUserSettings
      {% end %}

      {% if Avram::Model.all_subclasses.find(&.name.== :OauthClient.id) %}
        include Shield::SaveOauthClientUserSettings
      {% end %}
    {% end %}
  end
end
