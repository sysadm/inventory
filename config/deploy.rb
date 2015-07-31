# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'inventory.mulitel.be'
set :deploy_user, 'inventory'
set :repo_url, 'git@github.com:sysadm/inventory.git'

set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

set :tests, []

# Default value for :pty is false
#set :pty, false

set :linked_files, %w{config/database.yml config/application.yml config/secrets.yml}
set :linked_dirs, %w{log csv tmp/pids tmp/cache tmp/sockets public/assets}

set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
before 'deploy:restart', 'deploy:custom_symlink'

namespace :deploy do
  task :restart do
    invoke 'delayed_job:restart'
    invoke 'unicorn:restart'
  end
  task :custom_symlink do
    on "inventory@inventory.multitel.be" do
      execute "ln -sfn #{release_path}/bin/production.sh ~/bin/production.sh"
    end
  end
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
