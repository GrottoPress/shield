module Shield::UpdateUser
  macro included
    include Shield::SaveEmail
    include Shield::UpdatePassword

    permit_columns :email

    attribute password : String
    attribute password_confirmation : String
  end
end
