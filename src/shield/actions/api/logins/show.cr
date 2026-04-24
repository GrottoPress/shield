module Shield::Api::Logins::Show
  macro included
    skip :require_logged_out

    authorize_user do |user|
      super || user.id == login.user_id
    end

    # get "/logins/:login_id" do
    #   json LoginSerializer.new(login: login)
    # end

    getter login : Login do
      LoginQuery.find(login_id)
    end
  end
end
