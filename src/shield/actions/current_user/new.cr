module Shield::CurrentUser::New
  macro included
    skip :require_logged_in

    # get "/account/new" do
    #   operation = RegisterCurrentUser.new
    #   html NewPage, operation: operation
    # end
  end
end
