module Shield::UserOptions
  macro included
    include Shield::BelongsToUser

    column bearer_login_notify : Bool
    column login_notify : Bool
    column password_notify : Bool
  end
end
