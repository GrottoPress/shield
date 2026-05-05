module Shield::CurrentUser::New
  macro included
    skip :require_logged_in

    authorize { true }

    # get "/account/new" do
    #   operation = RegisterCurrentUser.new
    #   html NewPage, operation: operation
    # end
  end
end
