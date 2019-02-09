# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

require 'capistrano/rails'
require 'capistrano/passenger'

namespace :deploy do
   desc "Override Capistrano's default behavior, do not migrate on deploy"
   task :migrate do
     puts 'No migrate'
   end
 end
