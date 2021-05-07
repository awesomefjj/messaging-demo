class API::Entities::BaseResponse < Grape::Entity
  expose :code
  expose :status
  expose :message do |instance, options|
    with = options[:with]
    message = instance[:message]
    if message.is_a?(API::Entities::Pagination)
      with = API::Entities::Pagination
      message = message.object
    end
    with ? with.represent(message, options) : message
  end
end
