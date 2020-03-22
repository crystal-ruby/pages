# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task :create_post  do
  args = ARGV.dup
  args.shift
  args.each { |a| task a.to_sym do ; end }

  today = Time.now
  args.unshift today.day.to_s.rjust(2 , "0")
  args.unshift today.month.to_s.rjust(2 , "0")

  file = "app/views/posts/#{today.year}/_" + args.join("-") + ".haml"
  f = File.open(file , "w")
  f << "%p start"
end
