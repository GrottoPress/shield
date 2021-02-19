module Shield::UserOptions
  macro included
    include Shield::BelongsToUser

    column password_notify : Bool
  end
end
