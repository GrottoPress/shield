module Shield::OauthAuthorizationCredentials
  macro included
    include Shield::ParamCredentials

    def initialize(@password : String, @id : OauthAuthorization::PrimaryKeyType)
    end

    def self.new(
      operation : Shield::StartOauthAuthorization,
      oauth_authorization : Shield::OauthAuthorization
    )
      new(operation.code, oauth_authorization.id)
    end

    def oauth_authorization : OauthAuthorization
      oauth_authorization?.not_nil!
    end

    getter? oauth_authorization : OauthAuthorization? do
      OauthAuthorizationQuery.new.id(id).first?
    end

    def self.from_params?(params : Avram::Paramable) : self?
      from_params?(params.get? "code")
    end

    def self.from_params?(code : String?) : self?
      code.try { |code| from_token?(code) }
    end
  end
end
