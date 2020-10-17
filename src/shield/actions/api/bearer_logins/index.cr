module Shield::Api::BearerLogins::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/bearer-logins" do
    #   pages, bearer_logins = paginate(
    #     BearerLoginQuery.new
    #       .user_id(user.id)
    #       .status(BearerLogins::Status.new :started)
    #   )
    #
    #   json({
    #     status: "success",
    #     data: {
    #       bearer_logins: BearerLoginSerializer.for_collection(bearer_logins)
    #     },
    #     pages: {
    #       first: pages.path_to_page(1)
    #       previous: pages.path_to_previous,
    #       current: pages.path_to_page(page),
    #       next: pages.path_to_next,
    #       last: pages.path_to_page(page.total)
    #     }
    #   })
    # end

    def user
      current_or_bearer_user!
    end

    def authorize?(user : User) : Bool
      user.id == current_or_bearer_user.try &.id
    end
  end
end
