module Shield::UpdateUser # User::SaveOperation
  macro included
    permit_columns :email

    attribute password : String

    include Shield::SetPasswordDigestFromPassword
    include Shield::EndUserLoginsOnPasswordChange
    include Shield::ValidateUser
  end
end
