require 'spec_helper'

describe Specinfra::Processor do
  describe 'check_file_is_mounted' do
    let(:path) { '/proc' }
    let(:cmd) { Specinfra.command.get(:check_file_is_mounted, path) }

    def mock_output(stdout)
      Specinfra::CommandResult.new :stdout => stdout
    end

    context 'freebsd' do
      before do
        allow(Specinfra.backend).to receive(:run_command).with(cmd) { mock_output 'procfs on /proc (procfs, local)' }
      end
      it 'true when fs type matches' do
        expect(Specinfra::Processor.check_file_is_mounted(path, {:type => 'procfs'}, false)).to eq(true)
      end
      it 'false when fs type is different' do
        expect(Specinfra::Processor.check_file_is_mounted(path, {:type => 'ufs'}, false)).to eq(false)
      end
      it 'true when option matches' do
        expect(Specinfra::Processor.check_file_is_mounted(path, {:local => true}, false)).to eq(true)
      end
      it 'false when option is different' do
        expect(Specinfra::Processor.check_file_is_mounted(path, {:async => true}, false)).to eq(false)
      end
      context 'only_with' do
        it 'false when extra options present' do
          expect(Specinfra::Processor.check_file_is_mounted(path, {:local => true, :async => true}, true)).to eq(false)
        end
        it 'true when all options met' do
          expect(Specinfra::Processor.check_file_is_mounted(path, {:device => "procfs", :type => "procfs", :local => true}, true)).to eq(true)
        end
      end
    end
    context 'linux' do
      before do
        allow(Specinfra.backend).to receive(:run_command).with(cmd) { mock_output 'proc on /proc type proc (rw,noexec,nosuid,nodev)' }
      end
      it 'true when fs type matches' do
        expect(Specinfra::Processor.check_file_is_mounted(path, {:type => 'proc'}, false)).to eq(true)
      end
      it 'false when fs type is different' do
        expect(Specinfra::Processor.check_file_is_mounted(path, {:type => 'ufs'}, false)).to eq(false)
      end
      it 'true when option matches' do
        expect(Specinfra::Processor.check_file_is_mounted(path, {:noexec => true, :nosuid => true}, false)).to eq(true)
      end
      it 'false when option is different' do
        expect(Specinfra::Processor.check_file_is_mounted(path, {:noexec => true, :unknown => true}, false)).to eq(false)
      end
      context 'only_with' do
        it 'false when extra options present' do
          expect(Specinfra::Processor.check_file_is_mounted(path, {:noexec => true, :nosuid => true}, true)).to eq(false)
        end
        it 'true when all options are same' do
          expect(Specinfra::Processor.check_file_is_mounted(path, {:noexec => true, :nosuid => true, :nodev => true, :rw => true, :device => "proc", :type => "proc"}, true)).to eq(true)
        end
      end
    end
  end
end
