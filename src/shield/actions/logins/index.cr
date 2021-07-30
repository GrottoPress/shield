module Shield::Logins::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/logins" do
    #   html IndexPage, logins: logins, pages: pages
    # end

    def pages
      paginated_logins[0]
    end

    getter logins : Array(Login) do
      paginated_logins[1].results
    end

    private getter paginated_logins : Tuple(Lucky::Paginator, LoginQuery) do
      paginate LoginQuery.new.user_id(user.id).is_active
    end

    def user
      current_user!
    end

    def authorize?(user : User) : Bool
      user.id == self.user.id
    end
  end
end
