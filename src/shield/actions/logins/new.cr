module Shield::Logins::New
  macro included
    skip :require_logged_in

    # get "/login" do
    #   html NewPage
    # end
  end
end
