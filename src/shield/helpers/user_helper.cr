module Shield::UserHelper
  macro extended
    extend self

    def verify_user(email : String, password : String) : User?
      if user = user_from_email(email)
        user if verify_user?(user.not_nil!, password)
      else
        CryptoHelper.hash_bcrypt(password) # To mitigate timing attacks
        nil
      end
    end

    def verify_user?(user : User, password : String) : Bool
      CryptoHelper.verify_bcrypt?(password, user.password_digest)
    end

    def user_from_email(email : String) : User?
      UserQuery.new.email(email.downcase).first?
    end
  end
end
