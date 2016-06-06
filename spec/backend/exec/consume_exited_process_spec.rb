require 'spec_helper'

RSpec.describe 'exec backend' do
  before :all do
    set :backend, :exec
  end

  context 'when executed process had exited before read stdout and stderr,' do
    let(:backend) { Specinfra::Backend::Exec.new }

    it 'can consume stdout and stderr from buffer' do
      allow(IO).to receive(:select).and_wrap_original { |m, *args| sleep 1; m.call(*args) }
      result = backend.run_command("ruby -e 'STDOUT.puts \"stdout\"; STDERR.puts \"stderr\"'")
      expect(result.stdout.chomp).to eq('stdout')
      expect(result.stderr.chomp).to eq('stderr')
    end
  end

  context 'when executed process has exited between reading stdout and stderr,' do
    let(:backend) { Specinfra::Backend::Exec.new }

    it 'can consume stdout and stderr from buffer' do
      backend.stdout_handler = proc { |o| sleep 1 }
      result = backend.run_command("ruby -e 'STDOUT.puts \"stdout\"; STDOUT.close; STDERR.puts \"stderr\"'")
      expect(result.stdout.chomp).to eq('stdout')
      expect(result.stderr.chomp).to eq('stderr')
    end
  end

  context 'Output of stderr_handler' do
    let(:backend) { Specinfra::Backend::Exec.new }
    subject(:stderr) do
      allow(IO).to receive(:select).and_wrap_original { |m, *args| sleep 1; m.call(*args) }
      err = ''
      backend.stderr_handler = proc { |e| err += e }
      backend.run_command('echo foo 1>&2')
      err
    end

    it { expect(stderr).to eq "foo\n" }
  end
end
