Bdad::Application.routes.draw do

  resources :sketches
  resources :unsaved_sketches

  root :to => 'welcome#index'

end
