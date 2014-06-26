module Specinfra
  class Runner
    include Singleton
    def method_missing(meth, *args, &_block)
      backend.send(meth, *args)
    end
  end
end
