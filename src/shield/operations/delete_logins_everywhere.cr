module Shield::DeleteLoginsEverywhere
  macro included
    needs skip_current : Bool

    after_commit delete_logins_everywhere

    private def delete_logins_everywhere(login : Shield::Login)
      query = LoginQuery.new.user_id(login.user_id)
      query = query.id.not.eq(login.id) if skip_current
      query.delete
    end
  end
end
