module Shield::Api::Users::PasswordResets::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/users/:user_id/password-resets" do
    #   json ListResponse.new(
    #     password_resets: password_resets,
    #     user: user,
    #     pages: pages
    #   )
    # end

    def pages
      paginated_password_resets[0]
    end

    getter password_resets : Array(PasswordReset) do
      paginated_password_resets[1].results
    end

    private getter paginated_password_resets : Tuple(
      Lucky::Paginator,
      PasswordResetQuery
    ) do
      paginate PasswordResetQuery.new
        .user_id(user_id)
        .is_active
        .active_at.desc_order
    end

    getter user : User do
      UserQuery.find(user_id)
    end
  end
end
