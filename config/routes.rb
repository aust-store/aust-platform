Store::Application.routes.draw do

  devise_for :admin_users,
    controllers: {
      registrations: "admin/devise/registrations",
      sessions: "admin/devise/sessions"
    }

  devise_for :users,
    path: 'users/',
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
    resource :dashboard, controller: "dashboard" do
      get 'index' => 'dashboard#index'
    end

    resource :settings, only: [:show, :update]

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

    root :to => 'dashboard#index'
  end

  resource :cart, only: [:show, :update], controller: "store/cart" do
    resource :shipping_cost, only: [:create], controller: "store/cart/shipping_cost"
  end

  resource :cart_items, only: [:create, :destroy], controller: "store/cart_items"

  namespace :checkout, module: 'store/checkout' do
    resource :shipping, only: [:show, :create], controller: "shipping"
  end

  resources :products, only: [:show], controller: "store/products"

  get "home/index"
  root :to => 'store/home#index'
end
