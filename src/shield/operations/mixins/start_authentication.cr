module Shield::StartAuthentication(T)
  macro included
    include Shield::RequireIpAddress

    getter token = ""

    before_save do
      set_started_at
      set_ended_at
      set_status
      set_token
    end

    private def set_started_at
      started_at.value = Time.utc
    end

    private def set_ended_at
      ended_at.value = nil
    end

    private def set_status
      status.value = T::Status.new(:started)
    end

    private def set_token
      @token = CryptoHelper.generate_token
      token_digest.value = CryptoHelper.hash_sha256(token)
    end
  end
end
