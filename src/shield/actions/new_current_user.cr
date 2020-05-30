module Shield::NewCurrentUser
  macro included
    # get "/register" do
    #   html NewPage
    # end

    skip :require_logged_in
    before :require_logged_out
  end
end
