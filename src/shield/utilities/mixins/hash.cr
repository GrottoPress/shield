module Shield::Hash
  macro included
    def initialize(@plaintext : String)
    end

    def hash : String
    end

    def verify?(digest : String) : Bool
    end
  end
end
