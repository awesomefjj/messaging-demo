# 为接收者创建数据
class SendToReceiversService
  attr_reader :event
  def initialize(kind:, title:, content: nil, redirect_url: nil, extra_data: nil)
    @event_params = {
      kind: kind,
      title: title,
      content: content,
      redirect_url: redirect_url,
      extra_data: extra_data
    }
    @event = Tmdomain::Notifications.create_event(@event_params)
  end

  def receiver_to(receiver_type, receiver_ids, tenant_id)
    receiver_ids.each do |receiver_id|
      send_to_receiver(receiver_type, receiver_id, tenant_id)
    end
  end

  private

  attr_reader :event_params, :tenant_id

  def send_to_receiver(receiver_type, receiver_id, tenant_id = nil)
    Tmdomain::Notifications.notify(
      tenant_id,
      receiver_type,
      receiver_id,
      kind: event.kind,
      title: event.title,
      redirect_url: event.redirect_url,
      content: event.content,
      event_id: event.id,
      extra_data: event.extra_data
    )
  end
end