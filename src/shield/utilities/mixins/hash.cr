module Shield::Hash
  macro included
    def hash : String
    end

    def verify?(digest : String) : Bool
    end
  end
end
