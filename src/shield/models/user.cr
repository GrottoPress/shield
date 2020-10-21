module Shield::User
  macro included
    column email : String
    column password_digest : String
  end
end
