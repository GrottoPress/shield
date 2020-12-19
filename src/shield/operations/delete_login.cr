module Shield::DeleteLogin
  macro included
    @login : Login? = nil

    param_key :login

    attribute id : Int64

    before_run do
      validate_required id
      validate_login_exists
    end

    def run
      @login.try do |login|
        login if login.delete.rows_affected > 0
      end
    end

    private def validate_login_exists
      id.value.try do |value|
        @login = LoginQuery.new.id(value).first?
        id.add_error("does not exist") unless @login
      end
    end
  end
end
