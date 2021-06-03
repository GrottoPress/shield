module Shield::Deactivate
  macro included
    before_save do
      set_inactive_at
    end

    private def set_inactive_at
      return if inactive_at.value &&
        inactive_at.changed? &&
        !inactive_lt_active?

      if record.try &.active? || inactive_lt_active?
        inactive_at.value = Time.utc
      end
    end

    private def inactive_lt_active?
      inactive_at.value.try do |inactive|
        return unless active = active_at.value
        inactive < active
      end
    end
  end
end
