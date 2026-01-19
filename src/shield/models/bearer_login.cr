module Shield::BearerLogin
  macro included
    include Shield::BelongsToUser
    include Lucille::StatusColumns

    {% if Avram::Model.all_subclasses.any?(&.name.== :OauthClient.id) %}
      include Shield::OptionalBelongsToOauthClient
    {% end %}

    column name : String
    column scopes : Array(String)
    column token_digest : String
  end
end
