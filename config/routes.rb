Rails.application.routes.draw do
  resource :cast, only: :show
  resources :slash_commands, only: :create

  mount ActionCable.server => '/cable'

  get '/', to: redirect('/cast')
end
