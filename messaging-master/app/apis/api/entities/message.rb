class API::Entities::Message < Grape::Entity
  expose :id
  expose :tenant_id
  expose :receiver_type
  expose :receiver_id
  expose :kind
  expose :title
  expose :content
  expose :redirect_url
  expose :status 
  expose :event_id
  expose :extra_data
  expose :deleted_at
  expose :created_at
  expose :updated_at
end
