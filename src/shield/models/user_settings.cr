module Shield::UserSettings
  macro included
    include Lucille::JSON

    {% if Lucille::JSON.includers.find(&.name.== :BearerLogin.id) %}
      include Shield::BearerLoginUserSettings
    {% end %}

    {% if Lucille::JSON.includers.find(&.name.== :Login.id) %}
      include Shield::LoginUserSettings
    {% end %}

    {% if Lucille::JSON.includers.find(&.name.== :OauthClient.id) %}
      include Shield::OauthClientUserSettings
    {% end %}

    getter? password_notify : Bool = true

    def password_notify
      password_notify?
    end
  end
end
