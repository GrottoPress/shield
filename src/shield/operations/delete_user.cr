module Shield::DeleteUser
  macro included
    param_key :user

    attribute user_id : Int64

    needs current_user : User?

    def submit
      validate_required user_id
      validate_not_self

      yield self, delete_user
    end

    private def validate_not_self
      user_id.value.try do |value|
        user_id.add_error("is current user") if value == current_user.try &.id
      end
    end

    private def delete_user
      return unless valid?

      user_id.value.try do |value|
        user = UserQuery.find(value)
        user if user.delete.rows_affected > 0
      end
    end
  end
end
