module Shield::Sha256Hash
  macro included
    include Shield::Hash

    def hash : String
      hash(salt: true)
    end

    def hash(*, salt : Bool) : String
      digest = OpenSSL::Digest.new("SHA256")
      salt = salt ? Random::Secure.hex(16) : ""
      digest << salt << @plaintext

      "#{salt}#{digest.final.hexstring}"
    end

    def verify?(digest : String) : Bool
      raw_digest = digest[-64..]
      salt = digest.rchop(raw_digest)
      self.class.new("#{salt}#{@plaintext}").hash(salt: false) == raw_digest
    end
  end
end
