require "bundler/gem_tasks"
begin
  require "rspec/core/rake_task"
  require "octorelease"
rescue LoadError
end

if defined?(RSpec)
  task :spec => 'spec:all'
  task :default => 'spec:all'

  namespace :spec do
    task :all => [ :helper, :backend, :configuration, :processor, :command, :host_inventory ]

    RSpec::Core::RakeTask.new(:helper) do |t|
      t.pattern = "spec/helper/**/*_spec.rb"
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

    RSpec::Core::RakeTask.new(:processor) do |t|
      t.pattern = "spec/processor_spec.rb"
    end

    RSpec::Core::RakeTask.new(:command) do |t|
      t.pattern = "spec/command/**/*.rb"
    end

    RSpec::Core::RakeTask.new(:host_inventory) do |t|
      t.pattern = "spec/host_inventory/**/*_spec.rb"
    end
  end
end
