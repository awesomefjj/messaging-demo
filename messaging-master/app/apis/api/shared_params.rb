module API::SharedParams
  extend Grape::API::Helpers

  # 生产分页数据的JSON
  def wrap_collection(collection)
    API::Entities::Pagination.new(
      meta: {
        current_page: collection.current_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count,
        per_page: collection.limit_value
      },
      items: collection
    )
  end

end
