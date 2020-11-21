module Shield::DeleteLogin
  macro included
    @login : Login? = nil

    param_key :login

    attribute id : Int64

    def submit
      validate_required id
      validate_login_exists

      yield self, delete_login
    end

    private def validate_login_exists
      id.value.try do |value|
        @login = LoginQuery.new.id(value).first?
        id.add_error("does not exist") unless @login
      end
    end

    private def delete_login
      return unless valid?

      @login.try do |login|
        login if login.delete.rows_affected > 0
      end
    end
  end
end
