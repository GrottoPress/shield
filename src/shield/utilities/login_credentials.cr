module Shield::LoginCredentials
  macro included
    include Shield::BearerCredentials

    def initialize(@password : String, @id : Login::PrimaryKeyType)
    end

    def self.new(operation : Shield::StartLogin, login : Shield::Login)
      new(operation.token, login.id)
    end

    def login : Login
      login?.not_nil!
    end

    getter? login : Login? do
      LoginQuery.new.id(id).first?
    end
  end
end
