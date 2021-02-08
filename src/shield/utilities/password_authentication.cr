module Shield::PasswordAuthentication
  macro included
    @user : User?

    def initialize(@user : User)
    end

    def initialize(email : String)
      @user = UserQuery.new.email(email).first?
    end

    def verify(password : String) : User?
      bcrypt = BcryptHash.new(password)

      if user = @user
        user if bcrypt.verify?(user.password_digest)
      else
        bcrypt.fake_verify
      end
    end
  end
end
