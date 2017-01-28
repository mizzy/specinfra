require 'spec_helper'

set :backend, :exec

describe Specinfra.backend.run_command('echo $LANG').stdout.strip do
  it { should eq 'C' }
end

describe do
  before do
    set :backend, :exec

    ENV['LANG'] = 'C'
    set :env, :LANG => 'ja_JP.UTF-8'
  end
  let(:lang) { Specinfra.backend.run_command('echo $LANG').stdout.strip }
  it { expect(lang).to eq 'ja_JP.UTF-8' }
  it { expect(ENV['LANG']).to eq 'C' }
end

