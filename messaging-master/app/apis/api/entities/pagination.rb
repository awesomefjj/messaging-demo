class API::Entities::Pagination < Grape::Entity
  expose :meta
  expose :items do |instance, options|
    with = options[:with]
    options[:with].represent(instance[:items], options)
  end
end
