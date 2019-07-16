class Specinfra::Helper::DetectOs::Clearlinux < Specinfra::Helper::DetectOs
  def detect
    swupd_info = run_command('swupd info')
    if swupd_info.success?
      release = nil
      swupd_info.stdout.each_line do |line|
        release = line.gsub(/\s+/, '').split(':').last if line =~ /^Installed version:/
      end
      { :family => 'clearlinux', :release => release }
    end
  end
end
