require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "octorelease"

task :spec => 'spec:all'

namespace :spec do
  task :all => [ :helper, :backend, :configuration ]

  RSpec::Core::RakeTask.new(:helper) do |t|
    t.pattern = "spec/helper/*_spec.rb"
  end

  task :backend => 'backend:all'
  namespace :backend do
    backends = %w[exec ssh]

    task :all => backends

    backends.each do |backend|
      RSpec::Core::RakeTask.new(backend) do |t|
        t.pattern = "spec/backend/#{backend}/*_spec.rb"
      end
    end
  end

  RSpec::Core::RakeTask.new(:configuration) do |t|
    t.pattern = "spec/configuration_spec.rb"
  end
end
