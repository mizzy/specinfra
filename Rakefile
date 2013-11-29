require "bundler/gem_tasks"
require 'rspec/core/rake_task'

task :spec => 'spec:all'

namespace :spec do
  RSpec::Core::RakeTask.new(:all) do |t|
    t.pattern = "spec/**/*_spec.rb"
  end
end

