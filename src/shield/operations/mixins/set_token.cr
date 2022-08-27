module Shield::SetToken
  macro included
    getter token do
      Random::Secure.urlsafe_base64(32)
    end

    before_save do
      set_token
    end

    private def set_token
      token_digest.value = Sha256Hash.new(token).hash
    end
  end
end
