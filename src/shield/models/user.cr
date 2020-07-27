module Shield::User
  macro included
    has_many logins : Login
    has_many password_resets : PasswordReset

    has_one options : UserOptions

    column email : String
    column password_hash : String

    def can?(
      action : Shield::AuthorizedAction,
      record : Shield::Model | Shield::Model.class
    ) : Bool
      record.allow?(self, action)
    end
  end
end
