module Shield::SuccessQuery
  macro included
    def is_success
      success(true)
    end

    def is_ongoing(at time : Time = Time.utc)
      success(false).is_active(time)
    end

    def is_failure(at time : Time = Time.utc)
      success(false).is_inactive(time)
    end
  end
end
