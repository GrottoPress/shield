module Shield::BearerLoginCredentials
  macro included
    include Shield::BearerCredentials
    include Shield::ParamCredentials

    def initialize(
      @password : String,
      @id : BearerLogin::PrimaryKeyType
    )
    end

    def self.new(
      operation : BearerLogin::SaveOperation,
      bearer_login : Shield::BearerLogin
    )
      new(operation.token, bearer_login.id)
    end

    def bearer_login : BearerLogin
      bearer_login?.not_nil!
    end

    getter? bearer_login : BearerLogin? do
      BearerLoginQuery.new.id(id).preload_user.first?
    end

    {% if Avram::Model.all_subclasses.find(&.name.== :OauthClient.id) %}
      include Shield::OauthAccessTokenCredentials
    {% end %}
  end
end
