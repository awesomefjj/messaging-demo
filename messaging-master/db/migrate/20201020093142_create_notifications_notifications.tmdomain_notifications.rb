# This migration comes from tmdomain_notifications (originally 20191115015951)
class CreateNotificationsNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.send(Tmdomain::Notifications.config.tenant_id_type, :tenant_id)
      t.string :receiver_type
      t.string :receiver_id
      t.integer :kind, null: false
      t.string :title
      t.string :content
      t.string :redirect_url
      t.integer :status, null: false, default: 0
      t.integer :event_id, index: true
      t.json :extra_data
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :notifications, :tenant_id
    add_index :notifications, %i[receiver_type receiver_id]
  end
end
