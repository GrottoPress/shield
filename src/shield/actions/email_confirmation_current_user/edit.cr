module Shield::EmailConfirmationCurrentUser::Edit
  macro included
    include Shield::CurrentUser::Edit

    # get "/account/edit" do
    #   operation = UpdateCurrentUser.new(user, remote_ip: remote_ip)
    #   html EditPage, operation: operation
    # end
  end
end
