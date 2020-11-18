module Shield::CreateBearerLogin
  macro included
    permit_columns :name

    before_save do
      validate_required name, user_id
      validate_user_exists
      validate_name_unique
    end

    include Shield::ValidateScopes
    include Shield::StartAuthentication

    private def set_ended_at
      ended_at.value = started_at.value.not_nil! +
        Shield.settings.bearer_login_expiry
    end

    private def validate_user_exists
      user_id.value.try do |value|
        unless UserQuery.new.id(value).first?
          user_id.add_error("does not exist")
        end
      end
    end

    # Prevents a user from using a bearer login `name`
    # more than once.
    private def validate_name_unique
      name.value.try do |value|
        return unless uid = user_id.value

        if BearerLoginQuery.new.user_id(uid).name(value).first?
          name.add_error("is already used")
        end
      end
    end
  end
end
