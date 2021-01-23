module Shield::DeleteUser
  macro included
    param_key :user

    needs record : User
    needs current_user : User?

    before_run do
      validate_not_current_user
    end

    include Shield::DeleteOperation

    private def validate_not_current_user
      current_user.try do |current_user|
        add_error(:user, "is current user") if current_user.id == record.id
      end
    end
  end
end
