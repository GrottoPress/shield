struct PaginationSerializer < BaseSerializer
  def initialize(@pagination : Lucky::Paginator)
  end

  def render
    {
      current: @pagination.page,
      per_page: @pagination.per_page,
      total: @pagination.total,
    }
  end
end
