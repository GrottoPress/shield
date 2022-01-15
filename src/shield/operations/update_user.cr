module Shield::UpdateUser
  macro included
    permit_columns :email

    attribute password : String

    include Shield::SetPasswordDigestFromPassword
    include Shield::LogOutEverywhereOnPasswordChange
    include Shield::ValidateUser
  end
end
