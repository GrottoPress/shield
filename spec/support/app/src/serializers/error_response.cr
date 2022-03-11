struct ErrorResponse < ApiResponse
  def initialize(
    @error_message : String,
    @details : String? = nil,
    @message : String? = nil,
    @param : String? = nil
  )
  end

  private def status : Status
    Status::Error
  end

  private def data_json : NamedTuple
    super.merge({error: ErrorSerializer.new(@error_message, @details, @param)})
  end
end
