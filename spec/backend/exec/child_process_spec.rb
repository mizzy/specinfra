# Ref: https://github.com/sorah/infra_operator/blob/6259aada3fdd9d4bed5759115d39bd1df25a81f2/spec/backends/exec_spec.rb#L36

require 'spec_helper'

context "when executed process launches child process like a daemon, and the daemon doesn't close stdout,err" do
  before :all do
    set :backend, :exec
  end

  subject(:result) { Specinfra::Runner.run_command("ruby -e 'pid = fork { sleep 10; puts :bye }; Process.detach(pid); puts pid'") }

  it "doesn't block" do
    a = Time.now
    result # exec
    b = Time.now
    expect((b-a) < 3).to be_truthy

    expect(result.stderr).to be_empty
    expect(result.stdout.chomp).to match(/\A\d+\z/)
    Process.kill :TERM, result.stdout.chomp.to_i
  end
end
