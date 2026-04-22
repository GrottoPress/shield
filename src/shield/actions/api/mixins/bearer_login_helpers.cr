module Shield::Api::BearerLoginHelpers
  macro included
    include Shield::Api::LoginHelpers

    getter? current_bearer_login : BearerLogin? do
      bearer_login_headers.verify(bearer_scope)
    end

    def bearer_scope : String
      BearerScope.new(self.class).name
    end

    private getter bearer_login_headers do
      BearerLoginHeaders.new(context)
    end
  end
end
