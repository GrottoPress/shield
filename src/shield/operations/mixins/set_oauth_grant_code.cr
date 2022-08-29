module Shield::SetOauthGrantCode
  macro included
    getter code do
      Random::Secure.urlsafe_base64(24)
    end

    before_save do
      set_code
    end

    private def set_code
      code_digest.value = Sha256Hash.new(code).hash
    end
  end
end
