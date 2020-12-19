module Shield::DeleteUser
  macro included
    @user : User? = nil

    param_key :user

    attribute id : Int64

    needs current_user : User?

    before_run do
      validate_required id
      validate_not_current_user
      validate_user_exists
    end

    def run
      @user.try do |user|
        user if user.delete.rows_affected > 0
      end
    end

    private def validate_not_current_user
      id.value.try do |value|
        id.add_error("is current user") if value == current_user.try &.id
      end
    end

    private def validate_user_exists
      id.value.try do |value|
        @user = UserQuery.new.id(value).first?
        id.add_error("does not exist") unless @user
      end
    end
  end
end
