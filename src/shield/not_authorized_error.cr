module Shield
  class NotAuthorizedError < Error
    getter user : User
    getter action : AuthorizedAction
    getter record : Model

    def initialize(
      @user,
      @action,
      @record,
      @message = "Permission denied!",
      @cause : Exception? = nil
    )
      super message, cause
    end
  end
end
