module Shield::UserSettings
  macro included
    include Lucille::JSON

    {% if Avram::Model.all_subclasses.find(&.name.== :BearerLogin.id) %}
      include Shield::BearerLoginUserSettings
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Login.id) %}
      include Shield::LoginUserSettings
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :OauthClient.id) %}
      include Shield::OauthClientUserSettings
    {% end %}

    getter? password_notify : Bool = true

    def password_notify
      password_notify?
    end
  end
end
