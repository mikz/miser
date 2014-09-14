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
  task create: :app do
    system('createdb',  Miser::Database.opts.fetch(:database))
  end

  task drop: :app do
    system('dropdb',  Miser::Database.opts.fetch(:database))
  end

  desc 'Run DB migrations'
  task migrate: :app do
    require 'sequel'
    Sequel.extension :migration

    Sequel::Migrator.apply(Miser::Database, 'db/migrations')
  end
end

task :gpg do
  require 'miser'

  gpg = Miser::GPG.new

  gpg.generate(passphrase: ENV['PASSPHRASE'])

  Miser::KeyStore.import(gpg)

  puts gpg.public_key
  puts
  puts gpg.private_key
end
