Rails.application.routes.draw do
  root 'freelancers#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  match 'logout' => 'sessions#destroy', via: [:get, :delete]
  post 'signup' => 'users#create'

  resources :users, only: [:edit, :update, :show]
  resources :email_confirmations, only: [:show, :index]
  resources :password_reset, only: [:show, :update, :create]
  resources :ratings, only: [:create, :show]


  get 'bookings/index'
  post 'bookings/create'






  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :freelancers, only: [:show, :new, :update, :edit, :create, :index], as: 'profile' do |f|
    resources :enquiries, only: [:new]
  end

  # resources :freelancers, only: [:show, :new, :update, :edit, :create, :index], as: 'restricted' do |f|
  #   resources :booking
  # end


  resources :enquiries,except: [:new]
  resources :ratings, only: [:show,:create]


  mount ActionCable.server, at: '/cable'


end
