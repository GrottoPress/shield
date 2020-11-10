module Shield::RegisterUser
  macro included
    permit_columns :email

    attribute password : String

    include Shield::SaveEmail
    include Shield::CreatePassword
  end
end
