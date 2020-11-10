module Shield::UpdateUser
  macro included
    include Shield::SaveEmail
    include Shield::UpdatePassword

    permit_columns :email

    attribute password : String
  end
end
