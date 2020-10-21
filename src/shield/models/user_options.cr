module Shield::UserOptions
  macro included
    include Shield::BelongsToUser

    column login_notify : Bool
    column password_notify : Bool
  end
end
