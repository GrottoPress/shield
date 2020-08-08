module Shield::Users::Edit
  macro included
    skip :require_logged_out

    # get "/users/:user_id/edit" do
    #   html EditPage, user: user
    # end

    @[Memoize]
    def user
      UserQuery.find(user_id)
    end
  end
end
