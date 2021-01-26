module Shield::StatusColumns
  macro included
    column active_at : Time
    column inactive_at : Time?

    def active? : Bool
      inactive_at.nil? || inactive_at.not_nil! > Time.utc
    end

    def inactive? : Bool
      !active?
    end
  end
end
