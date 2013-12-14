require "bundler/gem_tasks"
require 'rspec/core/rake_task'

task :spec => 'spec:all'

namespace :spec do
  task :all => [ :helper, :backend, :configuration ]

  RSpec::Core::RakeTask.new(:helper) do |t|
    t.pattern = "spec/helper/*_spec.rb"
  end

  RSpec::Core::RakeTask.new(:backend) do |t|
    t.pattern = "spec/backend/*/*_spec.rb"
  end

  RSpec::Core::RakeTask.new(:configuration) do |t|
    t.pattern = "spec/configuration_spec.rb"
  end
end

