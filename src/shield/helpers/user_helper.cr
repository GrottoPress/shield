module Shield::UserHelper
  macro extended
    extend self

    def verify_user(email : String, password : String) : User?
      if user = user_from_email(email)
        user = user.not_nil!
        user if verify_user?(user, password)
      else
        # To mitigate timing attacks
        CryptoHelper.hash_bcrypt(password)
        nil
      end
    end

    def verify_user?(user : User, password : String) : Bool
      CryptoHelper.verify_bcrypt?(password, user.password_hash)
    end

    def user_from_email(email : String) : User?
      UserQuery.new.email(email).first?
    end
  end
end
