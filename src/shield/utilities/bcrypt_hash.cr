module Shield::BcryptHash
  macro included
    include Shield::Hash

    def initialize(@plaintext : String)
      @cost = LuckyEnv.production? ? 12 : 4
    end

    def initialize(@plaintext : String, @cost : Int32)
    end

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
