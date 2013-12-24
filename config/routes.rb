require "router_constraints"

Store::Application.routes.draw do
  api_actions = [:index, :create, :update, :show]

  devise_for :super_admin_user,
    path: "super_admin",
    controllers: {
      sessions: "super_admin/sessions"
    }

  devise_for :admin_users,
    path: "admin",
    path_names: {
      sign_up: false
    },
    controllers: {
      registrations: "admin/devise/registrations",
      sessions: "admin/devise/sessions"
    }

  devise_for :customers,
    controllers: {
      registrations: "store/devise/registrations",
      sessions: "store/devise/sessions"
    }

  devise_scope :admin_user do
    get "subscription" => "admin/devise/registrations#new", as: :subscription
  end

  resource :subscription_wizard, only: [:show, :update], controller: "subscription_wizard"

  namespace :consultor do
    resources :home, only: [:index]

    root :to => 'home#index'
  end

  namespace :super_admin, path: "super_admin" do
    resource :dashboard, controller: 'dashboard', only: [:show]
    resources :stores, only: [:index]
    resources :themes, controller: 'themes'

    root :to => 'dashboard#show'
  end

  namespace :admin do
    namespace :api do
      scope "/v1" do
        resources :inventory_items, only: [:index]
        resources :orders,          only: api_actions
        resources :carts,           only: [:create]
        resources :cart_items,      only: api_actions
        resources :taxonomies,      only: [:index]
        resources :manufacturers,   only: [:index]
        resources :theme_files,     only: [:index, :update]
        resources :mustache_commands, only: [:index]
        resource :orders_statistics, only: [:show]

        if Rails.env.development? || Rails.env.test?
          resource :resources, only: [:show]
        end
      end
    end
  end

  namespace :admin do
    resource :dashboard, controller: "dashboard" do
      get 'index' => 'dashboard#index'
    end

    resources :theme_editor, only: [:show], controller: "theme_editor"
    resources :theme_preview, only: [:show], controller: "theme_preview" do
      collection do
        delete :destroy
      end
    end

    resources :orders, only: [:index, :show, :update, :create]

    resource :settings, only: [:show, :update] do
      resource :payment_methods,
        controller: 'payment_methods', only: :show, module: 'settings' do

        resource :pagseguro_wizard,
          only: [:show, :update],
          controller: 'payment_methods/pagseguro_wizard'
      end

    end
    resources :taxonomies, only: [:index, :create, :update, :destroy]
    resource  :statistics, only: :show
    resources :store_themes, only: [:index, :update, :create]
    resources :pages, except: [:show]
    resource  :company_contact, only: [:edit, :update]
    resources :banners

    resources :marketing, only: [:index]

    resource :inventory do
      resources :items, controller: 'inventory/items' do
        collection do
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

    namespace :store do
      get 'dashboard' => 'dashboard#index'
    end

    resources :customers, only: [:index, :show, :edit, :update, :destroy]
    resources :users # admin_users

    namespace :offline, module: "offline" do
      resources :sales, only: :new
      root :to => 'sales#new'
    end

    root :to => 'dashboard#index'
  end

  namespace :mobile_admin, module: "mobile_admin" do
    resource :inventory do
      resources :items, controller: 'inventory/items' do
        resources :images, controller: 'inventory/items/images',
          only: [:index, :destroy, :create, :update]
      end
    end

    root to: 'inventory/items#index'
  end

  #
  # MAIN STORE PAGE
  #
  constraints RouterConstraints::Store.new do
    resource :cart, only: [:show, :update], controller: "store/cart" do
      resource :shipping_cost, only: [:create], controller: "store/cart/shipping_cost"
    end

    resources :categories, only: [:show], controller: "store/categories"
    resources :products, only: [:show], controller: "store/products"
    resources :pages,    only: [:show], controller: "store/pages"
    resource  :contact,  only: [:new, :create], controller: "store/contact" do
      get :success
    end

    resource :cart_items, only: [:create, :destroy], controller: "store/cart_items"

    namespace :checkout, module: 'store/checkout' do
      resource :shipping, only: [:show, :update], controller: "shipping"
      resource :payment,  only: [:show], controller: "payment"
      resource :success,  only: [:show], controller: "success"
    end

    namespace :gateway_notifications, module: 'store/gateway_notifications' do
      resource :pagseguro, only: :create, controller: "pagseguro"
    end

    root :to => 'store/home#index', as: "root"
  end

  #
  # MARKETING PAGE
  #
  constraints RouterConstraints::Marketing.new do
    namespace :marketing do
      resources :home, only: [:index]

    end
    root :to => 'marketing/home#index', as: :marketing_root
  end
end
