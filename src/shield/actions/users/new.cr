module Shield::Users::New
  macro included
    skip :require_logged_out

    # get "/users/new" do
    #   operation = RegisterUser.new
    #   html NewPage, operation: operation
    # end
  end
end
