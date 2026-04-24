module Shield::Logins::Show
  macro included
    skip :require_logged_out

    authorize_user do |user|
      super || user.id == login.user_id
    end

    # get "/logins/:login_id" do
    #   html ShowPage, login: login
    # end

    getter login : Login do
      LoginQuery.find(login_id)
    end
  end
end
