Samson::Application.routes.draw do
  resources :projects do
    resources :jobs, only: [:index, :new, :create, :show, :destroy]

    resources :deploys, only: [:index, :new, :create, :show, :destroy] do
      collection do
        get :active
      end

      member do
        get :changeset
      end
    end

    resources :releases, only: [:show, :index, :new, :create]

    resources :stages do
      resource :lock, only: [:create, :destroy]

      collection do
        patch :reorder
      end

      member do
        get :new_relic, to: 'new_relic#show'
      end
    end

    resource :changelog, only: [:show]

    resources :deploys, only: [:index, :new, :create, :show, :destroy] do
      collection do
        post :confirm
      end
    end

    resources :webhooks, only: [:index, :create, :destroy]
    resource  :commit_statuses, only: [:show]
  end

  resources :streams, only: [:show]

  resources :deploys, only: [] do
    collection do
      get :active
      get :recent
    end
  end

  resource :profile, only: [:show, :update]

  get '/auth/zendesk/callback', to: 'sessions#zendesk'
  get '/auth/github/callback', to: 'sessions#github'
  get '/auth/google/callback', to: 'sessions#google'
  get '/auth/failure', to: 'sessions#failure'

  get '/jobs/enabled', to: 'jobs#enabled', as: :enabled_jobs

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'

  resources :stars, only: [:create, :destroy]

  namespace :admin do
    resource :users, only: [:show, :update]
    resources :users, only: [:destroy]
    resource :projects, only: [:show]
    resources :commands, except: [:show]
    resource :lock, only: [:create, :destroy]
    resources :integrations, only: [:index, :create] do
      collection do
        get ':identifier', action: 'show'
        post ':identifier', { action: 'update', as: :update }
      end
    end
  end

  namespace :integrations do
    post "/travis/:token" => "travis#create", as: :travis_deploy
    post "/semaphore/:token" => "semaphore#create", as: :semaphore_deploy
    post "/tddium/:token" => "tddium#create", as: :tddium_deploy
  end

  get '/ping', to: 'ping#show'

  root to: 'projects#index'
end
