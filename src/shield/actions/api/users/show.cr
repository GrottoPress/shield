module Shield::Api::Users::Show
  macro included
    skip :require_logged_out

    # get "/users/:user_id" do
    #   json ItemResponse.new(user: user)
    # end

    getter user : User do
      UserQuery.find(user_id)
    end
  end
end
