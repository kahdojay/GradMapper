Rails.application.routes.draw do
  get '/', to: 'map#index'
  get '/graduates', to: 'map#graduates'
end
