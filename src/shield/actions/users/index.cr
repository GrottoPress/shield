module Shield::Users::Index
  macro included
    skip :require_logged_out

    # get "/users" do
    #   html IndexPage
    # end
  end
end
