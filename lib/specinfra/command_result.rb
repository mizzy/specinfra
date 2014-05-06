module Specinfra
  class CommandResult
    attr_reader :stdout, :stderr, :exit_status, :exit_signal

    def initialize(args = {})
      @stdout = args[:stdout] || ''
      @stderr = args[:stderr] || ''
      @exit_status = args[:exit_status] || 0
      @exit_signal = args[:exit_signal]
    end

    def success?
      @exit_status == 0
    end

    def failure?
      @exit_status != 0
    end

    def [](x)
      warn "CommandResult#[] is obsolete. Use accessors instead. in #{caller[0]}"
      case x
      when :stdout, :stderr, :exit_status, :exit_signal
        self.send(x)
      end
    end
  end
end
