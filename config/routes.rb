Rails.application.routes.draw do
  get '/', to: 'welcome#index'
  get '/graduates', to: 'welcome#graduates'
  resources :cohorts
  resources :graduates
end
