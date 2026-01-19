module Shield::BearerLoginVerifier
  macro included
    include Shield::Verifier

    def verify!(scope : Shield::BearerScope | String | Nil = nil)
      verify(scope).not_nil!
    end

    def verify(scope : Shield::BearerScope | String | Nil = nil)
      yield self, verify(scope)
    end

    def verify(scope : Shield::BearerScope | String | Nil = nil) : BearerLogin?
      bearer_login? if verify?(scope)
    end

    def verify?(scope : Shield::BearerScope | String | Nil = nil) : Bool?
      return unless bearer_login_id? && bearer_login_token?
      sha256 = Sha256Hash.new(bearer_login_token)

      if bearer_login?.try(&.status.active?) &&
        (!scope || bearer_login.scopes.includes?(scope.to_s))

        sha256.verify?(bearer_login.token_digest)
      else
        sha256.fake_verify
      end
    end

    def bearer_login
      bearer_login?.not_nil!
    end

    getter? bearer_login : BearerLogin? do
      bearer_login_id?.try do |id|
        BearerLoginQuery.new.id(id).preload_user.first?
      end
    end

    def bearer_login_id
      bearer_login_id?.not_nil!
    end

    def bearer_login_token : String
      bearer_login_token?.not_nil!
    end

    {% if Avram::Model.all_subclasses.any?(&.name.== :OauthClient.id) %}
      include Shield::OauthAccessTokenVerifier
    {% end %}
  end
end
