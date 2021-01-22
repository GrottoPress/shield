module Shield::Users::Edit
  macro included
    skip :require_logged_out

    # get "/users/:user_id/edit" do
    #   operation = UpdateUser.new(user, current_login: current_login)
    #   html EditPage, operation: operation
    # end

    @[Memoize]
    def user : User
      UserQuery.find(user_id)
    end
  end
end
