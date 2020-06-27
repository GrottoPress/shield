module Shield::UserOptions
  macro included
    belongs_to user : User

    column login_notify : Bool
    column password_notify : Bool
  end
end
