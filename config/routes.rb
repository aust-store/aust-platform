Store::Application.routes.draw do
  devise_for :admin_users,
    controllers: {
      registrations: "admin/users/registrations",
      sessions: "admin/users/sessions"
    }

  get "home/index"

  get "store(/:id)" => "store#show"

  namespace :admin do
    resource :dashboard, controller: "dashboard" do
      get 'index' => 'dashboard#index'
    end

    resource :inventory do
      resources :goods do
        collection do
          post 'search' => "goods#search"
          get 'new_good_or_balance'
        end

        resources :balances, controller: 'goods/balances'
      end
    end

    resources :customers do
      resources :receivables, controller: 'financial/receivables'
    end

    namespace :financial do
      resources :receivables
    end

    namespace :store do
      get 'dashboard' => 'dashboard#index'
    end

    root :to => 'dashboard#index'
  end

  root :to => 'store#show'
end
