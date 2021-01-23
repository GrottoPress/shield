module Shield::BcryptHash
  macro included
    include Shield::Hash

    @cost : Int32 = Shield.settings.bcrypt_cost

    def hash : String
      Crypto::Bcrypt::Password.create(@plaintext, @cost).to_s
    end

    def verify?(digest : String) : Bool
      Crypto::Bcrypt::Password.new(digest).verify(@plaintext)
    rescue
      false
    end

    def fake_verify : Nil
      fake_digest = "$2a$#{@cost}$MDRDOM0J0WuR1lwb\
        xxfuL.l.KhYyl7qra4d3zM4l78ysspIYM8ngC"

      verify?(fake_digest)
    end
  end
end
