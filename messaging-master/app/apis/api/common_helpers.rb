module API::CommonHelpers
  # options 支持：with
  def success!(msg = nil, options = {})
    result = { code: 0, status: 'success', message: '成功' }
    result.update(message: msg) if msg
    error! API::Entities::BaseResponse.represent(result, options).as_json, 200
  end

  def failed!(msg, options = {})
    code = options.delete(:code) || 101_001
    result = { code: code, status: 'failed', message: msg.respond_to?(:errors) ? msg.errors.full_messages : msg }
    error! API::Entities::BaseResponse.represent(result, options).as_json, 200
  end

  def not_found!
    failed!(API::Codes[404], code: 404)
  end
end
