module Specinfra
  class Runner
    include Singleton
    def method_missing(meth, *args, &block)
      if os.include?(:family) && os[:family] == 'windows'
        Specinfra.backend.send(meth, *args)
      else
        Specinfra::Command::Processor.send(meth, *args)
      end
    end
  end
end
