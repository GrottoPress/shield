module Shield::VerifyUser
  macro included
    needs email : String
    needs password : String = ""

    def submit
      yield self, submit
    end

    def submit!
      submit.not_nil!
    end

    def submit : User?
      user! if authenticate?
    rescue
      nil
    end

    def authenticate? : Bool
      VerifyLogin.verify_bcrypt?(password, user!.password_hash)
    rescue
      false
    end

    def user! : User
      user.not_nil!
    end

    @[Memoize]
    def user : User?
      UserQuery.new.email(email).first?
    end
  end
end
