module Shield::StartAuthentication
  macro included
    getter token = ""

    before_save do
      set_started_at
      set_ended_at
      set_token
    end

    private def set_started_at
      started_at.value = Time.utc
    end

    private def set_ended_at
      ended_at.value = nil
    end

    private def set_token
      @token = CryptoHelper.generate_token
      token_digest.value = CryptoHelper.hash_sha256(token)
    end
  end
end
