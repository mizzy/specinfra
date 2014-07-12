class Specinfra::Command::Base::File < Specinfra::Command::Base
  def check_is_directory(directory)
    "test -d #{escape(directory)}"
  end
end


