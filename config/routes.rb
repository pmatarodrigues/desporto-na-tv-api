Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get '/zapping', to: 'application#zapping'
  get '/zapping/today', to: 'application#zapping_today'
end
