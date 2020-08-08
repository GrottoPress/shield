module Shield::CurrentUser::New
  macro included
    skip :require_logged_in

    # get "/register" do
    #   html NewPage
    # end
  end
end
