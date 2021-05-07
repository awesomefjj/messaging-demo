class API::Root < Grape::API
  format :json
  prefix :api
  rescue_from ActiveRecord::RecordNotFound, -> (_e) { not_found! }

  mount API::V1::Root

  # 健康检查
  get :healthz do
    'OK'
  end

  add_swagger_documentation \
    info: {
      title: "TMF API",
      # description: "",
      # contact_name: "Xiaohui",
      # contact_email: "xiaohui@tanmer.com",
    },
    tags: [
      { name: 'healthz', description: '健康检查' },
      { name: 'messages', description: '消息' },
      { name: 'push', description: '推送消息事件至第三方平台' },
    ]
end
