module Shield::Deactivate
  macro included
    before_save do
      set_inactive_at
    end

    private def set_inactive_at
      inactive_at.value = Time.utc if record.try &.active?
    end
  end
end
