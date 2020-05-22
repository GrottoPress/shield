class Shield::NotAuthorizedError < Exception
  getter record : Model
  getter user : User
  getter action : AuthorizedAction

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
