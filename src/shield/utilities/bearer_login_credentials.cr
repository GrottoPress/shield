module Shield::BearerLoginCredentials
  macro included
    include Shield::BearerCredentials

    def initialize(
      @password : String,
      @id : BearerLogin::PrimaryKeyType
    )
    end

    def self.new(
      operation : Shield::CreateBearerLogin,
      bearer_login : Shield::BearerLogin
    )
      new(operation.token, bearer_login.id)
    end

    def bearer_login : BearerLogin
      bearer_login?.not_nil!
    end

    getter? bearer_login : BearerLogin? do
      BearerLoginQuery.new.id(id).first?
    end
  end
end
