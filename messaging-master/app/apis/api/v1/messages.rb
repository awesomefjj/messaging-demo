class API::V1::Messages < Grape::API
  helpers API::CommonHelpers
  helpers API::SharedParams

  notification_kinds = Tmdomain::Notifications.config.kinds.map(&:to_s)
  notification_statuses = Tmdomain::Notifications::Notification.statuses.keys.map(&:to_s)

  resources :messages do
    before do
      params[:receiver_type] = params[:receiver_type].classify if params[:receiver_type].present?
    end

    desc '创建消息'
    params do
      requires :receiver_type, type: String, desc: '接收方类型'
      requires :receiver_ids, type: Array[Integer], desc: '接收方的ID'
      requires :title, type: String, desc: '标题'
      requires :kind, type: String, values: notification_kinds, desc: '消息种类(normal: 正常 broadcast: 广播 warning: 报警 system: 系统)'
      optional :content, type: String, desc: '正文内容'
      optional :tenant_id, type: String, desc: '站点ID（暂时只有desk使用该属性）'
      optional :redirect_url, type: String, desc: '消息地址'
      optional :extra_data, type: JSON, desc: '其他数据'
    end
    post do
      event_params = params.slice(:kind, :title, :content, :redirect_url, :extra_data)
      service = SendToReceiversService.new(**event_params.symbolize_keys)
      service.receiver_to(params[:receiver_type], params[:receiver_ids], params[:tenant_id])
      # 返回这个事件的数据，方便让调用者将事件推送至app，这哥接口只负责消息持久化，不负责消息推送至app
      success! service.event, with: API::Entities::MessageEvent
    end

    desc '获取消息列表'
    params do
      optional :receiver_type, type: String, desc: '接收方类型'
      optional :receiver_id, type: Integer, desc: '接收方的ID'
      optional :status, type: String, values: notification_statuses, desc: '消息状态(unread, read, deleted)'
      optional :kind, type: String, values: notification_kinds, desc: '消息种类(normal: 正常 broadcast: 广播 warning: 报警 system: 系统)'
      optional :tenant_id, type: String, desc: '站点ID（暂时只有desk使用该属性）'
      optional :page, type: Integer, desc: '需要显示的页码'
      optional :page_size, type: Integer, desc: '每页显示数量, 默认20'
      optional :message_type, type: String, desc: '消息类型'
    end
    get do
      message_params = params.slice(:receiver_type, :receiver_id, :status, :kind, :tenant_id, :page, :page_size)
      query = Tmdomain::Notifications.notifications_of(**message_params.symbolize_keys)
      if message_type = params.delete(:message_type).presence
        query = query.where("extra_data->>'message_type' = ?", message_type.classify)
      end
      query = wrap_collection(query)
      success! query, with: API::Entities::Message
    end

    desc '所有消息通知标记为已读'
    params do
      requires :receiver_type, type: String, desc: '接收方类型'
      requires :receiver_id, type: Integer, desc: '接收方的ID'
      optional :tenant_id, type: String, desc: '站点ID（暂时只有desk使用该属性）'
      optional :kind, type: String, values: notification_kinds, desc: '消息种类(normal: 正常 broadcast: 广播 warning: 报警 system: 系统)'
    end
    put :read_all do
      Tmdomain::Notifications.read_all(params[:tenant_id], params[:receiver_type], params[:receiver_id], kind: params[:kind])
      success!
    end

    desc '未读消息数'
    params do
      requires :receiver_type, type: String, desc: '接收方类型'
      requires :receiver_id, type: Integer, desc: '接收方的ID'
      optional :tenant_id, type: String, desc: '站点ID（暂时只有desk使用该属性）'
    end
    get :unreads do
      unread_count = Tmdomain::Notifications.unreads(params[:receiver_type], params[:receiver_id], tenant_id: params[:tenant_id])
      success! unread_count
    end

    desc '硬删除 N 天前的通知(软删除之后，才能硬删除)'
    params do
      requires :ndays, type: Integer, desc: '天数'
    end
    delete :cleanup do
      Tmdomain::Notifications.cleanup(params[:ndays])
      success!
    end

    namespace ':id' do
      desc '获取消息信息'
      get do
        query = Tmdomain::Notifications.find_by_id(params[:id])
        success! query, with: API::Entities::Message
      end

      desc '消息设置为已读'
      put :read do
        query = Tmdomain::Notifications.read(params[:id])
        success! query, with: API::Entities::Message
      end

      desc '删除通知'
      delete do
        query = Tmdomain::Notifications.delete(params[:id])
        success! query, with: API::Entities::Message
      end
    end
  end
end
