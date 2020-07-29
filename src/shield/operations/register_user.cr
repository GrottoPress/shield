module Shield::RegisterUser
  macro included
    include Shield::SaveEmail
    include Shield::CreatePassword

    permit_columns :email

    attribute password : String
    attribute password_confirmation : String

    has_one_create save_user_options : SaveUserOptions, assoc_name: :options
  end
end
