class API::Entities::MessageEvent < Grape::Entity
  expose :id
  expose :kind
  expose :title
  expose :content
  expose :redirect_url
  expose :extra_data
  expose :created_by
  expose :notifications_count
  expose :read_count
  expose :created_at
  expose :updated_at
end
