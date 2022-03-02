module Shield::UpdatePassword
  macro included
    attribute password : String

    before_save do
      validate_password_required
    end

    include Shield::SetPasswordDigestFromPassword
    include Shield::EndUserLoginsOnPasswordChange
    include Shield::ValidatePassword

    private def validate_password_required
      validate_required password,
        message: Rex.t(:"operation.error.password_required")
    end
  end
end
