class Specinfra::Helper::DetectOs::Darwin < Specinfra::Helper::DetectOs
  def detect
    if run_command('uname -s').stdout =~ /Darwin/i
      release = run_command('uname -r').stdout.strip
      { :family => 'darwin', :release => release }
    end
  end
end
