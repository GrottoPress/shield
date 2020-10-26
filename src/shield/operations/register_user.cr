module Shield::RegisterUser
  macro included
    include Shield::SaveEmail
    include Shield::CreatePassword

    permit_columns :email

    attribute password : String
    attribute password_confirmation : String
  end
end
