# frozen_string_literal: true

class JpushService
  def initialize
    @pusher = JPush::Client.new(ENV['JPUSH_APP_KEY'], ENV['JPUSH_APP_SECRET']).pusher
  end

  def push_notification(audience_options, title:, alert: '', extras: {})
    audience = set_audience_options(audience_options)

    notification = \
      JPush::Push::Notification.new
                               .set_android(
                                 # 表示通知内容，会覆盖上级统一指定的 alert; 内容可以为空字符串，表示不展示到通知栏(android)
                                 alert: alert,
                                 # 表示通知标题，会替换通知里原来展示 App 名称的地方
                                 title: title,
                                 # 表示通知提醒方式， 可选范围为 -1～7 ，
                                 # 对应 Notification.DEFAULT_ALL = -1
                                 # 或者 Notification.DEFAULT_SOUND = 1， Notification.DEFAULT_VIBRATE = 2， Notification. DEFAULT_LIGHTS = 4 的任意 “or” 组合。
                                 # 默认按照 -1 处理。
                                 alert_type: 1 | 2 | 4,
                                 extras: extras
                               ).set_ios(
                                 alert: {
                                   title: title,
                                   body: alert
                                 },
                                 extras: extras
                               )

    return if audience_options[:all_user].blank? && audience.to_hash.blank?

    # apns_production: True 表示推送生产环境，False 表示要推送开发环境;
    push_payload = JPush::Push::PushPayload.new(
      platform: 'all',
      audience: audience_options[:all_user] ? 'all' : audience,
      notification: notification
    ).set_options(apns_production: Rails.env.production?)

    begin
      @pusher.push(push_payload)
    rescue JPush::Utils::Exceptions::JPushResponseError => e
      # 1011 代表推送目标超过 255 天不活跃，被排除在推送目标之外。
      raise e unless e.error_code == 1011
    end
  end

  private

  def set_audience_options(options)
    audience = JPush::Push::Audience.new
    options = options.symbolize_keys.slice(:tag, :tag_and, :tag_not, :alias, :registration_id, :segment, :abtest)
    options.each_pair do |k, v|
      audience.send("set_#{k}", v) if v.present?
    end
    audience
  end
end
