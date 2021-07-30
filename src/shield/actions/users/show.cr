module Shield::Users::Show
  macro included
    skip :require_logged_out

    # get "/users/:user_id" do
    #   html ShowPage, user: user
    # end

    getter user : User do
      UserQuery.find(user_id)
    end
  end
end
