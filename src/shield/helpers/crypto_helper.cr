module Shield::CryptoHelper
  macro extended
    extend self

    def hash_bcrypt(plaintext : String) : String
      Crypto::Bcrypt::Password
        .create(plaintext, Shield.settings.bcrypt_cost)
        .to_s
    end

    def verify_bcrypt?(plaintext : String, digest : String) : Bool
      Crypto::Bcrypt::Password.new(digest).verify(plaintext)
    rescue
      false
    end

    def hash_sha256(plaintext : String, *, salt = true) : String
      digest = OpenSSL::Digest.new("SHA256")
      salt = salt ? Random::Secure.hex(16) : ""

      digest << salt << plaintext
      "#{salt}#{digest.final.hexstring}"
    end

    def verify_sha256?(plaintext : String, digest : String) : Bool
      raw_digest = digest[-64..]
      salt = digest.rchop(raw_digest)
      hash_sha256("#{salt}#{plaintext}", salt: false) == raw_digest
    end

    def generate_token(size : Int32 = 24) : String
      Random::Secure.urlsafe_base64(size)
    end

    def encrypt_and_sign(plaintext : String) : String
      secret = Lucky::Server.settings.secret_key_base
      Lucky::MessageEncryptor.new(secret).encrypt_and_sign(plaintext)
    end

    def verify_and_decrypt!(ciphertext : String) : String
      secret = Lucky::Server.settings.secret_key_base
      plain = Lucky::MessageEncryptor.new(secret).verify_and_decrypt(ciphertext)
      String.new(plain)
    end

    def verify_and_decrypt(ciphertext : String) : String?
      verify_and_decrypt!(ciphertext)
    rescue
    end
  end
end
