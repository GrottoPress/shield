module Shield::Api::CurrentUser::Show
  macro included
    skip :require_logged_out

    # get "/account" do
    #   json UserSerializer.new(user: user)
    # end

    def user
      {% if Avram::Model.all_subclasses
        .map(&.stringify)
        .includes?("BearerLogin") %}

        current_user_or_bearer
      {% else %}
        current_user
      {% end %}
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
