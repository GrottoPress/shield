module Shield::PasswordAuthentication
  macro included
    def initialize(@user : Shield::User?)
    end

    def self.new(email : String)
      new UserQuery.new.email(email).first?
    end

    def verify(password : String)
      bcrypt = BcryptHash.new(password)

      if user = @user
        user if bcrypt.verify?(user.password_digest)
      else
        bcrypt.fake_verify
      end
    end
  end
end
