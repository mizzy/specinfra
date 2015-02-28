class Specinfra::Helper::DetectOs::Esxi < Specinfra::Helper::DetectOs
  def self.detect
    if run_command('vmware -v').success?
      line = run_command('vmware -v').stdout
      if line =~ /VMware ESXi (.*)/
        release = $1
      end
      { :family => 'esxi', :release => release }
    end
  end
end
