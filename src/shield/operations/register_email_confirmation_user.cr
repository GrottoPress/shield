module Shield::RegisterEmailConfirmationUser
  macro included
    include Shield::SaveEmail
    include Shield::CreatePassword

    attribute password : String
    attribute password_confirmation : String

    has_one_create save_user_options : SaveUserOptions, assoc_name: :options

    include Shield::DeleteSession(EmailConfirmationSession)
  end
end
