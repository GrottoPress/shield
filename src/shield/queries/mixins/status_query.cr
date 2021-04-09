module Shield::StatusQuery
  macro included
    def is_active
      where(&.inactive_at.is_nil.or &.inactive_at.gt(Time.utc))
    end
  end
end
