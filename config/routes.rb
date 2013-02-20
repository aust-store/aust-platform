Store::Application.routes.draw do
  api_actions = [:index, :create, :update, :show]

  namespace :consultor do
    resources :home, only: [:index]

    root :to => 'home#index'
  end

  devise_for :admin_users,
    controllers: {
      registrations: "admin/devise/registrations",
      sessions: "admin/devise/sessions"
    }

  devise_for :users,
    controllers: {
      registrations: "store/devise/registrations",
      sessions: "store/devise/sessions"
    }

  namespace :superadmin do
    resource :dashboard, controller: 'dashboard'
    resources :companies, controller: 'companies'
    root :to => 'companies#index'
  end

  namespace :admin do
    namespace :api do
      scope "/v1" do
        resources :inventory_items, only: [:index]
        resources :orders,          only: api_actions
        resources :carts,           only: api_actions
        resources :taxonomies,      only: [:index]
      end
    end

    resource :dashboard, controller: "dashboard" do
      get 'index' => 'dashboard#index'
    end

    resources :orders, only: [:index, :show, :update, :create]

    resource :settings, only: [:show, :update] do
      resource :payment_methods, controller: 'payment_methods', only: :show, module: 'settings' do
        resource :pagseguro_wizard, only: [:show, :update], controller: 'payment_methods/pagseguro_wizard'
      end
    end

    resources :taxonomies, only: [:index, :create, :update, :delete]

    resource :inventory do
      resources :items, controller: 'inventory/items' do
        collection do
          get 'new_item_or_entry'

          resource :search, controller: 'inventory/items/search', only: [] do
            post "index"
            post "for_adding_entry"
          end
        end

        resources :entries, controller: 'inventory/entries',
          only: [:index, :new, :create, :update]

        resources :images, controller: 'inventory/items/images',
          only: [:index, :destroy, :create, :update]
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

    resources :users

    namespace :offline, module: "offline" do
      resources :sales, only: :new
      root :to => 'sales#new'
    end

    root :to => 'dashboard#index'
  end

  resource :cart, only: [:show, :update], controller: "store/cart" do
    resource :shipping_cost, only: [:create], controller: "store/cart/shipping_cost"
  end

  resource :cart_items, only: [:create, :destroy], controller: "store/cart_items"

  namespace :checkout, module: 'store/checkout' do
    resource :shipping, only: [:show, :update], controller: "shipping"
    resource :payment,  only: [:show], controller: "payment"
    resource :success,  only: [:show], controller: "success"
  end

  resources :products, only: [:show], controller: "store/products"

  namespace :gateway_notifications, module: 'store/gateway_notifications' do
    resource :pagseguro, only: :create, controller: "pagseguro"
  end

  root :to => 'store/home#index'
end
