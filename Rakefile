require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :console do
  require 'miser'
  begin
    require 'pry'
    Pry.toplevel_binding.pry
  rescue LoadError
    require 'irb'
    ARGV.clear
    IRB.start
  end
end
