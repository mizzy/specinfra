module Specinfra::Helper::RunCommand
  def run_command(command)
    Specinfra.backend.run_command(command)
  end
end
