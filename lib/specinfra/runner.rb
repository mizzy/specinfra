module Specinfra
  class Runner
    include Singleton
    def method_missing(meth, *args, &block)
      backend.send(meth, *args)
    end
  end
end
