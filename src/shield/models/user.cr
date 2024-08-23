module Shield::User
  macro included
    {% if Avram::Model.all_subclasses.find(&.name.== :BearerLogin.id) %}
      include Shield::HasManyBearerLogins
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :EmailConfirmation.id) %}
      include Shield::HasManyEmailConfirmations
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Login.id) %}
      include Shield::HasManyLogins
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :OauthClient.id) %}
      include Shield::HasManyOauthClients
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :OauthGrant.id) %}
      include Shield::HasManyOauthGrants
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :PasswordReset.id) %}
      include Shield::HasManyPasswordResets
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :UserOptions.id) %}
      include Shield::HasOneUserOptions
    {% elsif Lucille::JSON.includers.find(&.name.== :UserSettings.id) %}
      include Shield::UserSettingsColumn
    {% end %}

    column email : String
    column password_digest : String
  end
end
