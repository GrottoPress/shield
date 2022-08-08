module Shield::Sha256Hash
  macro included
    include Shield::Hash

    def hash : String
      hash(salt: true)
    end

    def hash(*, salt : Bool) : String
      salt = salt ? Random::Secure.hex(16) : ""
      digest = Digest::SHA256.hexdigest("#{salt}#{@plaintext}")
      "#{salt}#{digest}"
    end

    def verify?(digest : String) : Bool
      raw_digest = digest[-64..]
      salt = digest.rchop(raw_digest)
      new_digest = self.class.new("#{salt}#{@plaintext}").hash(salt: false)

      Crypto::Subtle.constant_time_compare(new_digest, raw_digest)
    end

    def fake_verify : Nil
      fake_digest = "54495e76128a0e67b1bd467a2a67277c9d1c3c93\
        2506c8b725d91938dee1fecfe35579bc4efb62949b2cbf62bc40029a"

      verify?(fake_digest)
    end
  end
end
