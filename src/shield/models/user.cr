module Shield::User
  macro included
    has_many logins : Login
    has_many password_resets : PasswordReset

    column email : String
    column password_hash : String

    def self.from_email!(
      address : String,
      *,
      preload_logins = false,
      preload_password_resets = false
    ) : self
      from_email(
        address,
        preload_logins: preload_logins,
        preload_password_resets: preload_password_resets
      ).not_nil!
    end

    def self.from_email(
      address : String,
      *,
      preload_logins = false,
      preload_password_resets = false
    ) : self?
      query = UserQuery.new
      query.preload_logins if preload_logins
      query.preload_password_resets if preload_password_resets
      query.email(address.downcase).first?
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
