module Shield::StartAuthentication
  macro included
    before_save do
      set_started_at
      set_ended_at
    end

    include Shield::SetToken

    private def set_started_at
      started_at.value = Time.utc
    end

    private def set_ended_at
      ended_at.value = nil
    end
  end
end
