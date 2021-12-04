module Shield::DeleteUser
  macro included
    needs current_user : User?

    before_delete do
      validate_not_current_user
    end

    private def validate_not_current_user
      current_user.try do |current_user|
        return if current_user.id != record.id

        id.add_error Rex.t(
          :"operation.error.self_delete_forbidden",
          user_id: record.id
        )
      end
    end
  end
end
