module Shield::SaveUserOptions
  macro included
    param_key :user

    permit_columns :login_notify, :password_notify

    before_save do
      validate_required login_notify, password_notify, user_id
      validate_user_exists
    end

    private def validate_user_exists
      user_id.value.try do |value|
        unless UserQuery.new.id(value).first?
          user_id.add_error("does not exist")
        end
      end
    end
  end
end
