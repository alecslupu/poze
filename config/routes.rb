Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "user/omniauth_callbacks" }

  devise_scope :user do
    get '/users/auth/:provider' => 'user/omniauth_callbacks#passthru'
  end

end
