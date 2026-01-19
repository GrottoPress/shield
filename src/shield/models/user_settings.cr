module Shield::UserSettings
  macro included
    include Lucille::JSON

    {% if Avram::Model.all_subclasses.any?(&.name.== :BearerLogin.id) %}
      include Shield::BearerLoginUserSettings
    {% end %}

    {% if Avram::Model.all_subclasses.any?(&.name.== :Login.id) %}
      include Shield::LoginUserSettings
    {% end %}

    {% if Avram::Model.all_subclasses.any?(&.name.== :OauthClient.id) %}
      include Shield::OauthClientUserSettings
    {% end %}

    getter? password_notify : Bool = true

    def password_notify
      password_notify?
    end
  end
end
