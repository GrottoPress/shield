module Shield::UpdateBearerLogin
  macro included
    permit_columns :name

    before_save do
      validate_status_active
    end

    include Shield::ValidateBearerLogin

    private def validate_status_active
      record.try do |bearer_login|
        return if bearer_login.status.active?
        name.add_error Rex.t(:"operation.error.bearer_login_inactive")
      end
    end
  end
end
