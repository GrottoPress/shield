module Shield::SetToken
  macro included
    getter token = ""

    before_save do
      set_token
    end

    private def set_token
      @token = CryptoHelper.generate_token
      token_digest.value = Sha256Hash.new(token).hash
    end
  end
end
