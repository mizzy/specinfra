require 'spec_helper'

backend = Specinfra::Backend::Exec.new

context 'Output of stdout_handler' do
  subject(:stdout) do
    out = ''
    backend.stdout_handler = Proc.new {|o| out += o }
    backend.run_command('echo foo')
    out
  end

  it { expect(stdout).to eq "foo\n" }
end

context 'Output of stderr_handler' do
  subject(:stderr) do
    err = ''
    backend.stderr_handler = Proc.new {|e| err += e }
    backend.run_command('echo foo 1>&2')
    err
  end

  it { expect(stderr).to eq "foo\n" }
end
