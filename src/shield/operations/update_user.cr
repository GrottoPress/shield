module Shield::UpdateUser
  macro included
    permit_columns :email

    attribute password : String

    include Shield::SaveEmail
    include Shield::UpdatePassword
  end
end
