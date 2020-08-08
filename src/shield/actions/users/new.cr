module Shield::Users::New
  macro included
    skip :require_logged_out

    # get "/users/new" do
    #   html NewPage
    # end
  end
end
