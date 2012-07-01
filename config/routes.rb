Store::Application.routes.draw do
  devise_for :admin_users,
    controllers: {
      registrations: "admin/users/registrations",
      sessions: "admin/users/sessions"
    }

  get "home/index"

  namespace :admin do
    resource :dashboard, controller: "dashboard" do
      get 'index' => 'dashboard#index'
    end

    resource :inventory do
      resources :goods do
        collection do
          get 'new_good_or_balance'

          resource :search, controller: 'goods/search', only: [] do
            post "index"
            post "for_adding_balance"
          end
        end

        resources :balances, controller: 'goods/balances'
        resources :images, controller: 'goods/images', only: [:index,:delete]
      end
    end

    resources :customers do
      resources :account_receivables, controller: 'financial/account_receivables'
    end

    namespace :financial do
      resources :account_receivables
    end

    namespace :store do
      get 'dashboard' => 'dashboard#index'
    end

    root :to => 'dashboard#index'
  end

  # we want to use :store_id instead of :id for consistence
  get "store/:store_id" => "store#show", as: "store"
  resources :store, only: [:index] do
    resource :cart, only: [:show], controller: "store/cart"
  end

  root :to => 'store#index'
end
