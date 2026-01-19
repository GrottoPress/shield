module Shield::OauthClient
  macro included
    include Lucille::StatusColumns
    include Shield::BelongsToUser # Developer

    {% if Avram::Model.all_subclasses.any?(&.name.== :BearerLogin.id) %}
      include Shield::HasManyBearerLogins
    {% end %}

    {% if Avram::Model.all_subclasses.any?(&.name.== :OauthGrant.id) %}
      include Shield::HasManyOauthGrants
    {% end %}

    column name : String
    column redirect_uris : Array(String)
    column secret_digest : String?

    def confidential? : Bool
      !public?
    end

    def public? : Bool
      secret_digest.nil?
    end
  end
end
