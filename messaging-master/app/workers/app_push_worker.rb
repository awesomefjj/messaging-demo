# 推送消息至app
class AppPushWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(event_id, audience)
    @event = Tmdomain::Notifications.find_event(event_id)
    push_message_to_app!(audience) if audience.present?
  end

  private

  def push_message_to_app!(audience)
    data = {
      title: @event.title,
      alert: @event.content.to_s,
      extras: @event.extra_data
    }
    JpushService.new.push_notification(audience, data)
  end
end
