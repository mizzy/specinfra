require 'spec_helper'

def command(cmd)
  Specinfra::Runner.run_command(cmd)
end

shared_examples "IO checks" do
    let (:generator) { "seq 1 #{max}" }
    let (:expected) { (1..max).map { |x| x.to_s }.join("\n") << "\n" }

    it "stdout only" do
        out = command(generator).stdout
        expect(out).to eq expected
    end

    it "stderr only" do
        out = command("#{generator} >&2" ).stderr
        expect(out).to eq expected
    end

    it "stdout then stderr" do
        cmd = command("#{generator}; #{generator} >&2" )
        expect(cmd.stdout).to eq expected
        expect(cmd.stderr).to eq expected
    end

    it "stderr then stdout" do
        cmd = command("#{generator} >&2; #{generator}" )
        expect(cmd.stdout).to eq expected
        expect(cmd.stderr).to eq expected
    end

    it "stdout and stderr" do
        cmd = command("(#{generator} &); #{generator} >&2; sleep 2" )
        expect(cmd.stdout).to eq expected
        expect(cmd.stderr).to eq expected
    end
end

describe "buffer overflow problem" do
    before :all do
        set :backend, :exec
    end

    context "with small output amount" do
        let (:max) { 10 }
        include_examples "IO checks"
    end

    context "with huge output amount" do
        let (:max) { 999999 }
        include_examples "IO checks"
    end
end
