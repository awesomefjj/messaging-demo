# This migration comes from tmdomain_notifications (originally 20200130085711)
class CreateTmdomainNotificationsEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_events do |t|
      t.integer :kind, null: false
      t.string :title
      t.string :content
      t.string :redirect_url
      t.jsonb :extra_data
      t.send(Tmdomain::Notifications.config.user_id_type, :created_by, index: true)
      t.integer :notifications_count, default: 0, null: false
      t.integer :read_count, default: 0, null: false
      t.timestamps
    end
  end
end
