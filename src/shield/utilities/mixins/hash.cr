module Shield::Hash
  abstract def hash : String
  abstract def verify?(digest : String) : Bool
end
