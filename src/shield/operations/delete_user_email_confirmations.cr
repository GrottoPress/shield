module Shield::DeleteUserEmailConfirmations
  macro included
    after_commit delete_email_confirmations

    private def delete_email_confirmations(user : Shield::User)
      EmailConfirmationQuery.new.user_id(user.id).delete
    end
  end
end
