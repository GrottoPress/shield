module Shield::Activate
  macro included
    before_save do
      set_active_at
      set_inactive_at
    end

    private def set_active_at
      active_at.value = Time.utc
    end

    private def set_inactive_at
      inactive_at.value = nil
    end
  end
end
