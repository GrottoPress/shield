module Shield::OptionalBelongsToUser
  macro included
    belongs_to user : User?
  end
end
