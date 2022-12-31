module Shield::StartOauthGrant
  macro included
    attribute granted : Bool
    attribute code_challenge : String
    attribute code_challenge_method : String

    attribute redirect_uri : String
    attribute response_type : String
    attribute state : String

    include Lucille::Activate
    include Lucille::SetUserIdFromUser
    include Shield::SetOauthClientIdFromOauthClient
    include Shield::SetOauthGrantCode

    before_save do
      set_inactive_at
      set_success
      set_code_challenge_method
      set_code_challenge # Set challenge method before this
      set_redirect_uri

      validate_authorization_granted
      validate_redirect_uri_required
      validate_redirect_uri_valid
      validate_response_type_valid
    end

    include Shield::ValidateOauthGrant

    private def validate_oauth_client_exists
      return if oauth_client
      previous_def
    end

    private def validate_authorization_granted
      return if granted.value
      granted.add_error Rex.t(:"operation.error.authorization_denied")
    end

    private def validate_redirect_uri_required
      return unless type.value.try(&.authorization_code?)

      validate_required redirect_uri,
        message: Rex.t(:"operation.error.redirect_uri_required")
    end

    private def validate_redirect_uri_valid
      redirect_uri.value.try do |value|
        oauth_client!.try do |client|
          return if value.in?(client.redirect_uris)
          redirect_uri.add_error Rex.t(:"operation.error.redirect_uri_invalid")
        end
      end
    end

    private def validate_response_type_valid
      response_type.value.try do |value|
        return if OauthResponseType.new(value).code?
        response_type.add_error Rex.t(:"operation.error.response_type_invalid")
      end
    end

    private def set_inactive_at
      return unless type.value.try(&.authorization_code?)

      expiry = Shield.settings.oauth_authorization_code_expiry
      active_at.value.try { |value| inactive_at.value = value + expiry }
    end

    private def set_success
      success.value = false
    end

    private def set_code_challenge
      return unless type.value.try(&.authorization_code?)

      code_challenge.value.try do |value|
        values = {code_challenge: hash_challenge(value)}

        metadata.value.try do |_metadata|
          return metadata.value = _metadata.merge(**values)
        end

        metadata.value = OauthGrantMetadata.from_json(values.to_json)
      end
    end

    private def set_code_challenge_method
      return unless type.value.try(&.authorization_code?)

      code_challenge_method.value.try do |value|
        values = {code_challenge_method: value}

        metadata.value.try do |_metadata|
          return metadata.value = _metadata.merge(**values)
        end

        metadata.value = OauthGrantMetadata.from_json(values.to_json)
      end
    end

    private def set_redirect_uri
      return unless type.value.try(&.authorization_code?)

      redirect_uri.value.try do |value|
        values = {redirect_uri: value}

        metadata.value.try do |_metadata|
          return metadata.value = _metadata.merge(**values)
        end

        metadata.value = OauthGrantMetadata.from_json(values.to_json)
      end
    end

    # Hash code challenge if method is "plain"
    private def hash_challenge(challenge)
      metadata.value.try do |meta|
        OauthGrantPkce.new(meta).challenge_method.plain? ?
          OauthGrantPkce.hash(challenge) :
          challenge
      end
    end
  end
end
