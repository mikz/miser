require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :app do
  require 'miser'
end

task console: :app  do
  begin
    require 'pry'
    Pry.toplevel_binding.pry
  rescue LoadError
    require 'irb'
    ARGV.clear
    IRB.start
  end
end

namespace :db do
  desc 'Run DB migrations'
  task migrate: :app do
    require 'sequel'
    Sequel.extension :migration

    Sequel::Migrator.apply(Miser::Server.database, 'db/migrations')
  end
end
