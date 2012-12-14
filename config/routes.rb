Store::Application.routes.draw do

  devise_for :admin_users,
    controllers: {
      registrations: "admin/devise/registrations",
      sessions: "admin/devise/sessions"
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

  # we want to use :store_id instead of :id for consistence
  get "store/:store_id" => "store/home#index", as: "store"
  resources :store, only: [], controller: "store/home" do

    resource :cart, only: [:show, :update], controller: "store/cart" do
      resource :shipping_cost, only: [:create], controller: "store/cart/shipping_cost"
    end

    resource :cart_items, only: [:create, :destroy], controller: "store/cart_items"

    resource :checkout, only: [], controller: "store/checkout" do
      get "review"
      get "confirm_informations"
    end

    resources :products, only: [:show], controller: "store/products"
  end

  get "home/index"
  root :to => 'home#index'
end
