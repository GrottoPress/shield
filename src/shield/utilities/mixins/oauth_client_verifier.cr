module Shield::OauthClientVerifier
  macro included
    include Shield::Verifier

    def verify : OauthClient?
      oauth_client? if verify?
    end

    def verify? : Bool?
      return unless oauth_client_id? && oauth_client_secret?
      sha256 = Sha256Hash.new(oauth_client_secret)

      if oauth_client?.try(&.confidential?) &&
        oauth_client?.try(&.status.active?)

        sha256.verify?(oauth_client.secret_digest.not_nil!)
      else
        sha256.fake_verify
      end
    end

    def oauth_client
      oauth_client?.not_nil!
    end

    getter? oauth_client : OauthClient? do
      oauth_client_id?.try do |id|
        OauthClientQuery.new.id(id).preload_user.first?
      end
    end

    def oauth_client_id
      oauth_client_id?.not_nil!
    end

    def oauth_client_secret : String
      oauth_client_secret?.not_nil!
    end
  end
end
