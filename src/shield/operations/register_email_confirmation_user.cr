module Shield::RegisterEmailConfirmationUser
  macro included
    include Shield::SaveEmail
    include Shield::CreatePassword

    attribute password : String
    attribute password_confirmation : String

    needs session : Lucky::Session

    has_one_create save_user_options : SaveUserOptions, assoc_name: :options

    after_save delete_session

    private def delete_session(user : User)
      EmailConfirmationSession.new(session).delete
    end
  end
end
