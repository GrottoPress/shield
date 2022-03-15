abstract struct SuccessSerializer < BaseSerializer
  @pages : Lucky::Paginator?

  def render
    json = super

    @pages.try do |pages|
      json = json.merge({pages: {
        current: pages.page,
        per_page: pages.per_page,
        total: pages.total,
      }})
    end

    json
  end

  def self.list(list : Array, *args, **named_args)
    list.map { |item| new(item, *args, **named_args) }
  end

  private def status : Status
    Status::Success
  end
end
