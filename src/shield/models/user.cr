module Shield::User
  macro included
    has_many logins : Login
    has_many password_resets : PasswordReset

    has_one options : UserOptions

    column email : String
    column password_digest : String
  end
end
