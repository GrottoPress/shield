module Shield::SuccessColumn
  macro included
    column success : Bool

    def success_status : SuccessStatus
      SuccessStatus.new(self)
    end
  end
end
