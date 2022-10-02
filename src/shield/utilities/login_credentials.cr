module Shield::LoginCredentials
  macro included
    include Shield::BearerCredentials
    include Shield::ParamCredentials

    def initialize(@password : String, @id : Login::PrimaryKeyType)
    end

    def self.new(operation : Login::SaveOperation, login : Shield::Login)
      new(operation.token, login.id)
    end

    def login : Login
      login?.not_nil!
    end

    getter? login : Login? do
      LoginQuery.new.id(id).preload_user.first?
    end
  end
end
