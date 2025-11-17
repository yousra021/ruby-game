Rails.application.routes.draw do
  # Page de login par défaut
  root "sessions#new"

  # Authentification
  resources :users, only: [:new, :create]
  resources :sessions, only: [:create]
  get "/login", to: "sessions#new"
  delete '/logout', to: 'sessions#destroy', as: :logout

  # Personnages : création, sélection, édition des stats
  resources :characters, only: [:new, :create, :show] do
    member do
      post :set_active
      get :edit_stats
      patch :update_stats
    end
    
    collection do
      get :select
    end
  
    resources :inventory_items, only: [:index, :show, :create] do
      member do
        patch :equip
        patch :unequip
      end
    end
  end
  
  # equipement temporaire
  post '/equip_item/:id', to: 'inventory_items#equip_direct', as: :equip_item

  # Sélection de personnage
  post "/characters/select/:id", to: "characters#select_character", as: "select_character"

  # Dashboard
  get "/dashboard", to: "dashboard#home", as: "dashboard"
  get "/dashboard/index", to: "dashboard#index"

  get "/dashboard/steps", to: "dashboard#steps", as: :dashboard_steps
  get "/dashboard/quest_log", to: "dashboard#quest_log", as: :dashboard_quest_log
  get 'dashboard/quests', to: 'dashboard#quests', as: :dashboard_quests

  get '/quest_result/:id', to: 'quest_results#show', as: :quest_result
  get "/step_result/:step_id", to: "steps#result", as: :step_result

  post "/combats/:id/use_item", to: "combats#use_item", as: :use_combat_item

  resources :dashboard, only: [:index, :show] do
    post 'complete_step', on: :member
  end

  resources :characters do
    post 'start_quest', on: :member
    patch :update_stats, on: :member
  end
  post 'start_quest/:id', to: 'dashboard#start_quest', as: :start_quest

  
  # gamemaster
  namespace :gamemaster do
    get '/', to: 'dashboard#index', as: :dashboard
  
    get "player_tracking", to: "dashboard#players", as: :player_tracking
    get 'quest_success/:id', to: 'quests#success', as: :quest_success
    get 'quest_failed/:id', to: 'quests#failed', as: :quest_failed
    get 'quests/new_step_template', to: 'quests#new_step_template'
    resources :quests
  
    resources :quest_results, only: [:show]
    resources :quests, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :npcs, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :equipments
    resources :character_quest_progresses, only: [:index, :show]
  end
    
  # combat
  resources :quest_steps, only: [:show] do
    post 'attack', on: :member
  end
  
  get 'start_combat/:step_id', to: 'quest_steps#start_combat', as: :start_combat

  # enigmes
  resources :riddles, only: [:show] do
    post 'check', on: :member  # crée la route check_riddle_path(@riddle)
  end
  # combat
  resources :combats, only: [:show] do
    post :attack, on: :member
    get :success, on: :member
    get :failure, on: :member
  end

  post 'combats/:id/flee', to: 'combats#flee', as: :flee_combat


  # Optionnel : Health check
  get "up" => "rails/health#show", as: :rails_health_check

  get "/test", to: "pages#test"

end

