module Shield::PasswordAuthentication
  macro included
    @user : User?

    def initialize(@user : User)
    end

    def initialize(email : String)
      @user = UserQuery.new.email(email.downcase).first?
    end

    def verify(password : String) : User?
      bcrypt = BcryptHash.new(password)

      if @user
        @user if bcrypt.verify?(@user.not_nil!.password_digest)
      else
        bcrypt.hash # To mitigate timing attacks
        nil
      end
    end
  end
end
