module Shield::SetSecret
  macro included
    getter secret do
      Random::Secure.urlsafe_base64(32)
    end

    before_save do
      set_secret
    end

    private def set_secret
      secret_digest.value = Sha256Hash.new(secret).hash
    end
  end
end
