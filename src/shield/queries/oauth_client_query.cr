module Shield::OauthClientQuery
  macro included
    include Lucille::StatusQuery

    def is_public
      secret_digest.is_nil
    end

    def is_confidential
      secret_digest.is_not_nil
    end
  end
end
