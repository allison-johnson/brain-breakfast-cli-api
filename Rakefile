require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative "./lib/brain_breakfast_cli_api.rb"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :console do
    binding.pry
end
