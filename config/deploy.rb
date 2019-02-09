# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "ruby-x"
set :repo_url, "https://github.com/ruby-x/ruby-x.github.io.git"
#set :repo_url, "git@github.com:ruby-x/ruby-x.github.io.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/vhosts/rubydesign.fi/ruby-x.org'

# Default value for :linked_files is []
#append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
set :local_user, -> { 'rubydesign' }
