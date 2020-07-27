module Shield::VerifyLogin
  macro included
    needs session : Lucky::Session

    def submit
      yield self, submit
    end

    def submit!
      submit.not_nil!
    end

    def submit : Login?
      return unless login.try &.status.started?
      expire_login! && return nil if login!.expired?
      login! if authenticate?
    rescue
      nil
    end

    def authenticate? : Bool
      self.class.verify_sha256?(login_token!, login!.token_hash)
    rescue
      false
    end

    def login! : Login
      login.not_nil!
    end

    @[Memoize]
    def login : Login?
      login_id.try { |id| LoginQuery.new.id(id.to_i64).first? }
    end

    def expire_login!
      DeactivateLogin.update!(
        login!,
        status: Login::Status.new(:expired)
      )
    end

    def set_session(id, token : String) : Nil
      session.set(:login_id, id.to_s)
      session.set(:login_token, token)
    end

    def delete_session : Nil
      session.delete(:login_id)
      session.delete(:login_token)
    end

    def login_id!
      login_id.not_nil!
    end

    def login_id
      session.get?(:login_id)
    end

    def login_token!
      login_token.not_nil!
    end

    def login_token
      session.get?(:login_token)
    end

    def self.hash_bcrypt(plaintext : String) : String
      Crypto::Bcrypt::Password.create(plaintext).to_s
    end

    def self.verify_bcrypt?(plaintext : String, hash : String) : Bool
      Crypto::Bcrypt::Password.new(hash).verify(plaintext)
    rescue
      false
    end

    def self.hash_sha256(plaintext : String) : String
      digest = OpenSSL::Digest.new("SHA256")
      digest << plaintext
      digest.final.hexstring
    end

    def self.verify_sha256?(plaintext : String, hash : String) : Bool
      hash_sha256(plaintext) == hash
    end

    def self.generate_token(size : Int32 = 32) : String
      Random::Secure.urlsafe_base64(size)
    end
  end
end
