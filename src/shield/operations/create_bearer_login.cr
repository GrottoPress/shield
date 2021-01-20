module Shield::CreateBearerLogin
  macro included
    permit_columns :name

    before_save do
      validate_required name, user_id
      validate_primary_key user_id, query: UserQuery
      validate_name_unique
    end

    include Shield::ValidateScopes
    include Shield::StartAuthentication

    private def set_ended_at
      ended_at.value = started_at.value! + Shield.settings.bearer_login_expiry
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
