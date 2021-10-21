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

  describe 'check_service_is_running' do
    let(:service_command) { Specinfra.command.get(:check_service_is_running, 'service_name') }
    let(:process_command) { Specinfra.command.get(:check_process_is_running, 'service_name') }

    context 'default settings' do
      it 'does not fall back to process checking if service checking succeeds' do
        allow(Specinfra.backend).to receive(:run_command).with(service_command) { CommandResult.new :exit_status => 0 }

        expect(Specinfra::Processor.check_service_is_running('service_name')).to eq(true)
      end

      context 'when service checking fails' do
        it 'falls back to checking by process and returns true if that succeeds' do
          allow(Specinfra.backend).to receive(:run_command).with(service_command) { CommandResult.new :exit_status => 1 }

          expect(Specinfra.backend).to receive(:run_command).with(process_command) { CommandResult.new :exit_status => 0 }

          expect(Specinfra::Processor.check_service_is_running('service_name')).to eq(true)
        end

        it 'falls back to checking by process and returns false if that fails' do
          allow(Specinfra.backend).to receive(:run_command).with(service_command) { CommandResult.new :exit_status => 1 }

          expect(Specinfra.backend).to receive(:run_command).with(process_command) { CommandResult.new :exit_status => 1 }

          expect(Specinfra::Processor.check_service_is_running('service_name')).to eq(false)
        end
      end
    end

    context 'no_service_process_fallback set to true' do
      it 'does not fall back to checking processes if service checking succeeds' do
        Specinfra.configuration.no_service_process_fallback(true)

        allow(Specinfra.backend).to receive(:run_command).with(service_command) { CommandResult.new :exit_status => 0 }

        expect(Specinfra::Processor.check_service_is_running('service_name')).to eq(true)
      end

      it 'does not fall back to checking processes if service checking fails' do
        Specinfra.configuration.no_service_process_fallback(true)

        allow(Specinfra.backend).to receive(:run_command).with(service_command) { CommandResult.new :exit_status => 1 }

        expect(Specinfra::Processor.check_service_is_running('service_name')).to eq(false)
      end
    end
  end
end
