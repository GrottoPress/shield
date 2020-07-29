module Shield::UpdateUser
  macro included
    include Shield::SaveEmail
    include Shield::UpdatePassword

    permit_columns :email

    attribute password : String
    attribute password_confirmation : String

    has_one_update save_user_options : SaveUserOptions, assoc_name: :options
  end
end
