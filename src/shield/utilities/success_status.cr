module Shield::SuccessStatus
  macro included
    def initialize(@record : Shield::SuccessColumn)
    end

    def to_s(io)
      io << at(Time.utc)
    end

    def at(time : Time) : Symbol
      case
      when success?
        :success
      when ongoing?(time)
        :ongoing
      when failure?(time)
        :failure
      else
        @record.status.at(time)
      end
    end

    delegate :success?, to: @record

    def ongoing?(at time : Time = Time.utc) : Bool
      !success? && @record.status.active?(time)
    end

    def failure?(at time : Time = Time.utc) : Bool
      !success? && @record.status.inactive?(time)
    end
  end
end
