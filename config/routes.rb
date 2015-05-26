Rails.application.routes.draw do
  post "sessions/ldap" => "sessions#create_ldap", as: "ldap_login"
  post "backups/initial" => "backups#initial", as: :initial_backup
  get "logout" => "sessions#destroy", as: "logout"
  get "login" => "sessions#new", as: "login"
  get "inventories/search/reset" => "inventories#reset", as: :reset
  get "inventories/search/:filter" => "inventories#search", as: :search
  get "inventory/autocomplete" => "inventories#autocomplete"
  get "users/ldap" => "users#import_new_users_from_ldap", as: :ldap_users_import
  get "backups/download/:id" => "backups#download", as: :download
  put "backups/rollback/:id" => "backups#rollback", as: :rollback
  put "inventories/switch/:id" => "inventories#switch", as: :switch_inventory
  put "departments/switch/:id" => "departments#switch", as: :switch_department
  put "kinds/switch/:id" => "kinds#switch", as: :switch_kind
  put "vendors/switch/:id" => "vendors#switch", as: :switch_vendor
  put "users/switch/:id" => "users#switch", as: :switch_user
  resources :backups
  resources :inventories
  resources :departments
  resources :vendors
  resources :kinds
  resources :admins
  resources :users
  resources :sessions
  root to: "inventories#index"
  match "*rest" => "application#not_found", via: [:get, :post, :put]
end
