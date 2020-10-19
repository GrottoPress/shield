module Shield::DeleteUser
  macro included
    @user : User? = nil

    param_key :user

    attribute user_id : Int64

    needs current_user : User?

    def submit
      validate_required user_id
      validate_not_current_user
      validate_user_exists

      yield self, delete_user
    end

    private def validate_not_current_user
      user_id.value.try do |value|
        user_id.add_error("is current user") if value == current_user.try &.id
      end
    end

    private def validate_user_exists
      user_id.value.try do |value|
        @user = UserQuery.new.id(value).first?
        user_id.add_error("does not exist") unless @user
      end
    end

    private def delete_user
      return unless valid?

      @user.try do |user|
        user if user.delete.rows_affected > 0
      end
    end
  end
end
