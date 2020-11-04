module Shield::CurrentUser::New
  macro included
    skip :require_logged_in

    # get "/account/new" do
    #   operation = RegisterCurrentUser.new(remote_ip: remote_ip)
    #   html NewPage, operation: operation
    # end
  end
end
