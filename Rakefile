require "bundler/gem_tasks"
require "bundler/gem_helper"
require 'rspec/core/rake_task'

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

desc 'Release gem and create a release on GitHub'
task 'create_release' => 'release' do
  require 'octokit'

  Octokit.configure do |c|
    c.login        = `git config --get github.user`.strip
    c.access_token = `git config --get github.token`.strip
  end

  t = Bundler::GemHelper.new

  current_version  = "v#{t.gemspec.version.to_s}"
  previous_version = ""
  `git tag`.split(/\n/).each do |tag|
    break if tag == current_version
    previous_version = tag
  end

  log = `git log #{previous_version}..#{current_version} --grep=Merge`

  repo = `git remote -v | grep origin`.match(/([\w-]+\/[\w-]+)\.git/)[1]

  description = []
  log.split(/commit/).each do |lines|
    lines.match(/Merge pull request \#(\d+)/) do |m|
      url = "https://github.com/#{repo}/pull/#{m[1]}"
      title = Octokit.pull_request(repo, m[1]).title
      description << "* [#{title}](#{url})"
    end
  end

  Octokit.create_release(
    repo,
    current_version,
    body: description.join("\n"),
  )
end
