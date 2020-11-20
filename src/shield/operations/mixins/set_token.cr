module Shield::SetToken
  macro included
    getter token = ""

    before_save do
      set_token
    end

    private def set_token
      @token = CryptoHelper.generate_token
      token_digest.value = CryptoHelper.hash_sha256(token)
    end
  end
end
