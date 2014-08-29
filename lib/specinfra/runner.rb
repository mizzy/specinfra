module Specinfra
  class Runner
    def self.method_missing(meth, *args)
      backend   = Specinfra.backend
      processor = Specinfra::Processor
      
      if ! os.include?(:family) || os[:family] != 'windows'
        if processor.respond_to?(meth)
          processor.send(meth, *args)
        elsif backend.respond_to?(meth)
          backend.send(meth, *args)
        else
          run(meth, *args)
        end
      else
        if backend.respond_to?(meth)
          backend.send(meth, *args)
        else
          run(meth, *args)
        end
      end
    end

    private
    def self.run(meth, *args)
      cmd = Specinfra.command.get(meth, *args)
      ret = Specinfra.backend.run_command(cmd)
      if meth.to_s =~ /^check/
        ret.success?
      else
        ret
      end
    end
  end
end
