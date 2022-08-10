module Shield::OauthClient
  macro included
    include Lucille::StatusColumns
    include Shield::BelongsToUser # Developer
    include Shield::HasManyBearerLogins

    column name : String
    column redirect_uri : String
    column secret_digest : String?

    def confidential? : Bool
      !public?
    end

    def public? : Bool
      secret_digest.nil?
    end
  end
end
