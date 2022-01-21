module Shield::Api::CurrentUser::Show
  macro included
    skip :require_logged_out

    # get "/account" do
    #   json({
    #     status: "success",
    #     data: {user: UserSerializer.new(user)}
    #   })
    # end

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
