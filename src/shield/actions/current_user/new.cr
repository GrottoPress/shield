module Shield::CurrentUser::New
  macro included
    skip :require_logged_in

    # get "/account/new" do
    #   html NewPage
    # end
  end
end
