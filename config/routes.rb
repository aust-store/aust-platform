Store::Application.routes.draw do
  namespace :admin do
    resources :dashboards
  end

  # root :to => 'welcome#index'
end
