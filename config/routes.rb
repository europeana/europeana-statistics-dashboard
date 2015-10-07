Rails.application.routes.draw do

  devise_for :accounts, :controllers => { :registrations => 'core/registrations' }, :path => 'accounts', :path_names => {:sign_up => 'secret_signup_only'}

  #NORMAL ROUTES --------------------------------------------------------------

  resources :accounts do
    get "revoke_session", on: :member
    
    namespace :core do
      resources :account_emails do
        get "confirmation", "resend_confirmation", on: :member
      end
      resources :permissions
      resources :projects do
        get "members", on: :member
        resources :db_connections, except: [:show]
        resources :datacasts do
          post "preview","upload", on: :collection
          get "file", on: :collection
          get "run_worker", on: :member
          get "change_d_or_m", on: :member
        end
        resources :datacast_pulls,only: [:create,:destroy,:edit,:update]
        resources :vizs do
        end
      end
    end
  end
  
  resources :accounts do
    resources :projects do
      namespace :impl do
        resources :aggregations do
          get "restart_all_aggregation_workers","datacasts", on: :member
          resources :providers do
            get "restart_worker", on: :member
          end
        end
        resources :reports, except: [:show]
      end
    end
  end

  #CUSTOM PUBLIC URLs --------------------------------------------------------------
  
  get 'switch_user' => 'switch_user#set_current_user'
  get 'approve/account/:id' => "accounts#change_approval"  
  get "/new", to: "core/projects#new", as: "_new_project"
  get "/:impl_report_id", to: "impl/reports#show", as: "impl_report"

  #
  get "/:account_id/projects", to: "accounts#show", as: "_account", :defaults => { :content => "projects" }
  get "/:account_id/dashboard", to: "accounts#dashboard", as: "dashboard"
  get "/:account_id/edit", to: "accounts#edit", as: "_edit_account"
  #
  get "/:account_id/:project_id", to: "core/projects#show", as: "_account_project"
  get "/:account_id/:project_id/edit", to: "core/projects#edit", as: "_edit_account_project"
  #
  #ROOT URL --------------------------------------------------------------
  root "static_pages#index"

end