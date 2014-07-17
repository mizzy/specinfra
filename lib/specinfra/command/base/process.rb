class Specinfra::Command::Base::Process < Specinfra::Command::Base
  def get(process, opts)
    "ps -C #{escape(process)} -o #{opts[:format]} | head -1"
  end
end
