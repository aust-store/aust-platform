Store::Application.routes.draw do
  namespace :admin do
    resources :dashboards

    resource :inventory do
      resources :goods
    end
  end

  # root :to => 'welcome#index'
end
