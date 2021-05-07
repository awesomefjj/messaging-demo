namespace :fix do
  desc '消息json数据添加targrt_id'
  task add_target_id: :environment do
    Tmdomain::Notifications::Notification.find_each do |notify|
      if notify.redirect_url.present?
        target_id = notify.redirect_url.split('/').last
        notify.extra_data ||= {}
        notify.extra_data['target_id'] = target_id.to_i
        notify.save
      end
    end
  end
end