module Shield::User
  macro included
    has_many logins : Login
    has_many password_resets : PasswordReset

    column email : String
    column password_hash : String

    def self.from_email!(address : String) : self
      from_email(address).not_nil!
    end

    def self.from_email(address : String) : self?
      UserQuery.new.email(address.downcase).first?
    end

    def can?(
      action : Shield::AuthorizedAction,
      record : Shield::Model | Shield::Model.class
    ) : Bool
      record.allow?(self, action)
    end

    def authenticate?(password : String) : Bool
      Login.verify?(password, password_hash)
    end
  end
end
