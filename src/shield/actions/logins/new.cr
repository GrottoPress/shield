module Shield::Logins::New
  macro included
    skip :require_logged_in

    # get "/log-in" do
    #   html NewPage
    # end
  end
end
