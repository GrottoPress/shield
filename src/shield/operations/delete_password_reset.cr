module Shield::DeletePasswordReset
  macro included
    @password_reset : PasswordReset? = nil

    param_key :password_reset

    attribute id : Int64

    before_run do
      validate_required id
      validate_password_reset_exists
    end

    def run
      @password_reset.try do |password_reset|
        password_reset if password_reset.delete.rows_affected > 0
      end
    end

    private def validate_password_reset_exists
      id.value.try do |value|
        @password_reset = PasswordResetQuery.new.id(value).first?
        id.add_error("does not exist") unless @password_reset
      end
    end
  end
end
