abstract struct ApiResponse
  enum Status
    Success
    Failure
    Error
  end

  include Lucille::Serializer

  @message : String?

  def render
    json = {status: status}
    @message.try { |message| json = json.merge({message: message}) }
    data_json.empty? ? json : json.merge({data: data_json})
  end

  private def data_json : NamedTuple
    NamedTuple.new
  end

  private abstract def status : Status
end
