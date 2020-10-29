module Shield::RegisterUser
  macro included
    permit_columns :email

    include Shield::SaveEmail
    include Shield::CreatePassword

    attribute password : String
    attribute password_confirmation : String
  end
end
