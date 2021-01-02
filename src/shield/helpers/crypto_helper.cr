module Shield::CryptoHelper
  macro extended
    extend self

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
