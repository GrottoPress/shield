module Shield::Api::Logins::Show
  macro included
    skip :require_logged_out

    # get "/logins/:login_id" do
    #   json LoginSerializer.new(login: login)
    # end

    getter login : Login do
      LoginQuery.find(login_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == login.user_id
    end
  end
end
