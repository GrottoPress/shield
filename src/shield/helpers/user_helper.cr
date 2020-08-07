module Shield::UserHelper
  macro extended
    extend self

    def verify_user(email : String, password : String) : User?
      user_from_email(email).try do |user|
        return user if verify_user?(user, password)
      end

      # To mitigate timing attacks
      CryptoHelper.hash_bcrypt(password)
      nil
    end

    def verify_user?(user : User, password : String) : Bool
      CryptoHelper.verify_bcrypt?(password, user.password_hash)
    end

    def user_from_email(email : String) : User?
      UserQuery.new.email(email).first?
    end
  end
end
