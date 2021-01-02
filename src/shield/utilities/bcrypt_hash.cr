module Shield::BcryptHash
  macro included
    include Shield::Hash

    def hash : String
      Crypto::Bcrypt::Password
        .create(@plaintext, Shield.settings.bcrypt_cost)
        .to_s
    end

    def verify?(digest : String) : Bool
      Crypto::Bcrypt::Password.new(digest).verify(@plaintext)
    rescue
      false
    end
  end
end
