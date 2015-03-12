Rails.application.routes.draw do
  # mount Soulmate::Server, at: '/autocomplete'
  get '/', to: 'welcome#index'
  get '/graduates', to: 'welcome#graduates'
  resources :cohorts
  resources :graduates
end
