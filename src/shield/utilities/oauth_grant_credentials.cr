module Shield::OauthGrantCredentials
  macro included
    include Shield::ParamCredentials

    def initialize(@password : String, @id : OauthGrant::PrimaryKeyType)
    end

    def self.new(
      operation : OauthGrant::SaveOperation,
      oauth_grant : Shield::OauthGrant
    )
      new(operation.code, oauth_grant.id)
    end

    def oauth_grant : OauthGrant
      oauth_grant?.not_nil!
    end

    getter? oauth_grant : OauthGrant? do
      OauthGrantQuery.new.id(id).preload_user.preload_oauth_client.first?
    end

    def self.from_params?(code : String?) : self?
      code.try { |code| from_token?(code) }
    end
  end
end
