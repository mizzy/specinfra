module Specinfra
  class Runner
    def self.method_missing(meth, *args)
      backend   = Specinfra.backend
      processor = Specinfra::Processor
      
      if os.include?(:family) && os[:family] == 'windows'
        if backend.respond_to?(meth)
          backend.send(meth, *args)
        else
          run(meth, *args)
        end
      else
        if processor.respond_to?(meth)
          processor.send(meth, *args)
        elsif backend.respond_to?(meth)
          backend.send(meth, *args)
        else
          run(meth, *args)
        end
      end
    end

    private
    def self.run(meth, *args)
      cmd = Specinfra.command.get(meth, *args)
      if meth.to_s =~ /^check/
        Specinfra.backend.run_command(cmd).success?
      else
        Specinfra.backend.run_command(cmd)
      end
    end
  end
end
