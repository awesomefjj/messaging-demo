Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get :_healthz, to: ->(_req) {
    # 检查 redis
    Redis.current.get('healthz')
    # 检查数据库版本
    ActiveRecord::Migration.check_pending!
    [200, {}, ["OK\n"]]
  }

  mount API::Root => '/'
  mount GrapeSwaggerRails::Engine => '/api/tm-docs'

  resource :dashboard, only: %i[show]
  resources :tenants do 
    get :search, on: :collection
      resources :messages, only: %i[index new create] do
        get :search, on: :collection
      end
    end
    resources :messages, only: %i[index show] do
      get :search, on: :collection
    end

  root to: 'dashboards#show'

end
