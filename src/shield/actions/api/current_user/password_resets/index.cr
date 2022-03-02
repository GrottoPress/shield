module Shield::Api::CurrentUser::PasswordResets::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/account/password-resets" do
    #   json({
    #     status: "success",
    #     data: {password_resets: PasswordResetSerializer.for_collection(
    #       password_resets
    #     )},
    #     pages: PaginationSerializer.new(pages)
    #   })
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
        .user_id(user.id)
        .is_active
        .active_at.desc_order
    end

    {% if Avram::Model.all_subclasses
      .map(&.stringify)
      .includes?("BearerLogin") %}

      def user
        current_user_or_bearer
      end
    {% else %}
      def user
        current_user
      end
    {% end %}

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
