module Shield::SetSecret
  macro included
    getter secret = ""

    before_save do
      set_secret
    end

    private def set_secret
      @secret = Random::Secure.urlsafe_base64(32)
      secret_digest.value = Sha256Hash.new(secret).hash
    end
  end
end
