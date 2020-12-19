module Shield::DeleteBearerLogin
  macro included
    @bearer_login : BearerLogin? = nil

    param_key :bearer_login

    attribute id : Int64

    before_run do
      validate_required id
      validate_bearer_login_exists
    end

    def run
      @bearer_login.try do |bearer_login|
        bearer_login if bearer_login.delete.rows_affected > 0
      end
    end

    private def validate_bearer_login_exists
      id.value.try do |value|
        @bearer_login = BearerLoginQuery.new.id(value).first?
        id.add_error("does not exist") unless @bearer_login
      end
    end
  end
end
