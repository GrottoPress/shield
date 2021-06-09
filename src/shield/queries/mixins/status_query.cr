module Shield::StatusQuery
  macro included
    def is_active
      is_active_at(Time.utc)
    end

    def is_active_at(time)
      where(&.inactive_at.is_nil.or &.inactive_at.gt(time))
    end
  end
end
