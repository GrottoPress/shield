module Shield::DeleteOperation
  macro included
    @deleted = false

    def run
      record.delete
      mark_as_deleted
      record
    end

    def deleted? : Bool
      @deleted == true
    end

    private def mark_as_deleted
      @deleted = true
    end
  end
end
