Rails.application.routes.draw do
  resource :cast, only: :show

  mount ActionCable.server => '/cable'

  get '/', to: redirect('/cast')
end
