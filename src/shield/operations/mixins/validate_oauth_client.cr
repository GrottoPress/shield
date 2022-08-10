module Shield::ValidateOauthClient
  macro included
    before_save do
      validate_name_required
      validate_name_unique
      validate_name_valid

      validate_redirect_uri_required
      validate_redirect_uri_unique
      validate_redirect_uri_valid

      validate_user_id_required
      validate_user_exists
    end

    include Lucille::ValidateStatus

    private def validate_name_required
      validate_required name,
        message: Rex.t(:"operation.error.name_required")
    end

    private def validate_name_unique
      return unless name.changed? || user_id.changed?

      name.value.try do |_name|
        user_id.value.try do |_user_id|
          if OauthClientQuery.new.user_id(_user_id).name(_name).any?
            name.add_error Rex.t(:"operation.error.name_exists", name: _name)
          end
        end
      end
    end

    private def validate_name_valid
      name.value.try do |value|
        return if value.matches?(/^[a-z\_][a-z0-9\s\_\-\(\)]*$/i)
        name.add_error Rex.t(:"operation.error.name_invalid", name: value)
      end
    end

    private def validate_redirect_uri_required
      validate_required redirect_uri,
        message: Rex.t(:"operation.error.redirect_uri_required")
    end

    private def validate_redirect_uri_unique
      return unless redirect_uri.changed? || user_id.changed?

      redirect_uri.value.try do |_redirect_uri|
        user_id.value.try do |_user_id|
          if OauthClientQuery.new
            .user_id(_user_id)
            .redirect_uri(_redirect_uri)
            .is_active
            .any?

            redirect_uri.add_error Rex.t(
              :"operation.error.redirect_uri_exists",
              redirect_uri: _redirect_uri
            )
          end
        end
      end
    end

    private def validate_redirect_uri_valid
      redirect_uri.value.try do |value|
        return unless value.includes?('#') || URI.parse(value).scheme.nil?

        redirect_uri.add_error Rex.t(
          :"operation.error.redirect_uri_invalid",
          redirect_uri: value
        )
      end
    end

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end

    private def validate_user_exists
      return unless user_id.changed?

      validate_foreign_key user_id,
        query: UserQuery,
        message: Rex.t(
          :"operation.error.user_not_found",
          user_id: user_id.value
        )
    end
  end
end
