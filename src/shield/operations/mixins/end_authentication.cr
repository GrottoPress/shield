module Shield::EndAuthentication
  macro included
    before_save do
      set_ended_at
    end

    private def set_ended_at
      ended_at.value = Time.utc if record.try &.active?
    end
  end
end
