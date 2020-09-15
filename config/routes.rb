Rails.application.routes.draw do
  
  get  'game/home'
  post 'game/create_room'
  get  'game/create_room'
  post 'game/join_room'
  get  'game/join_room'
  get  'game/room'
  post 'game/get_bs'
  get  'game/get_bs'
  post 'game/collect_bs'
  get  'game/collect_bs'
  post 'game/quiz'
  get  'game/quiz'
  post 'game/collect_answer'
  get  'game/collect_answer'
  post 'game/score'
  get  'game/score'
  post 'game/wait_for_next'
  get  'game/wait_for_next'

  get 'game/get_joined_users'
  get 'game/get_bs_stat'
  get 'game/get_answer_stat'
  get 'game/get_ready_stat'
  get 'game/kick_player'

  devise_for :users



  root to: "game#home"

  #match '*path' => redirect('/'), via: :get
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
