Store::Application.routes.draw do
  devise_for :admin_users,
    controllers: {
      registrations: "admin/users/registrations",
      sessions: "admin/users/sessions"
    }

  get "home/index"

  namespace :admin do
    resources :dashboards

    resource :inventory do
      resources :goods
    end

    root :to => 'dashboards#index'
  end

  root :to => 'home#index'
end
