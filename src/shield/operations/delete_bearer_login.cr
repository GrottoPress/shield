module Shield::DeleteBearerLogin
  macro included
    @bearer_login : BearerLogin? = nil

    param_key :bearer_login

    attribute bearer_login_id : Int64

    def submit
      validate_required bearer_login_id
      validate_bearer_login_exists

      yield self, delete_bearer_login
    end

    private def validate_bearer_login_exists
      bearer_login_id.value.try do |value|
        @bearer_login = BearerLoginQuery.new.id(value).first?
        bearer_login_id.add_error("does not exist") unless @bearer_login
      end
    end

    private def delete_bearer_login
      return unless valid?

      @bearer_login.try do |bearer_login|
        bearer_login if bearer_login.delete.rows_affected > 0
      end
    end
  end
end
