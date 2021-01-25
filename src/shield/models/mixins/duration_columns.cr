module Shield::DurationColumns
  macro included
    column started_at : Time
    column ended_at : Time?

    def active? : Bool
      ended_at.nil? || ended_at.not_nil! > Time.utc
    end

    def inactive? : Bool
      !active?
    end
  end
end
