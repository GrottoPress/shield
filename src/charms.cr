module Lucky
  class MessageEncryptor
    # Set default digest to `:sha256`
    def initialize(
      @secret : String,
      @cipher_algorithm = "aes-256-cbc",
      @digest = :sha256
    )
      previous_def
    end
  end

  class MessageVerifier
    # Set default digest to `:sha256`
    def initialize(@secret : String, @digest = :sha256)
      previous_def
    end
  end
end
