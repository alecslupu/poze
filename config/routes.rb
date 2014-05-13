Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "user/omniauth_callbacks" }

  devise_scope :user do
    get '/users/auth/:provider' => 'user/omniauth_callbacks#passthru'
  end

  get '/about', to: 'home#index', as: :about
  get '/tos', to: 'home#index', as: :tos
  get '/privacy', to: 'home#index', as: :privacy
  root to: 'home#index'

end


=begin
  /tags
  /categories
  /pictures
  /newest
  /tags/:name
  /categories/:name
  /users/:name
  /pictures/:name
  /top/pictures/popular
  /top/pictures/viewed
  /top/pictures/downloads
  /top/pictures/comments
  /top/pictures/liked
  /pictures/:name/like
  /pictures/:name/share
  /pictures/:name/download
  /pictures/:name/comments
  /pictures/:name/comments/add
=end
