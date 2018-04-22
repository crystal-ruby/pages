# config valid only for current version of Capistrano
lock '3.10.2'

set :application, 'ruby-s'
set :repo_url, 'https://github.com/ruby-x/rubyx.github.com'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/vhosts/rubydesign/ruby-x.org'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :passenger_restart_command, 'passenger-config restart-app'

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
