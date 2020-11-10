module Shield::RegisterUser
  macro included
    permit_columns :email

    include Shield::SaveEmail
    include Shield::CreatePassword

    attribute password : String
  end
end
