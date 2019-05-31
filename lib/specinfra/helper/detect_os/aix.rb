class Specinfra::Helper::DetectOs::Aix < Specinfra::Helper::DetectOs
  def detect
    if run_command('uname -s').stdout =~ /AIX/i
      line = run_command('uname -rvp').stdout
      if line =~ /(\d+)\s+(\d+)\s+(.*)/ then
        oslevel = run_command('oslevel -s').stdout.chomp
        edition = run_command('chedition -l').stdout.chomp
        { :family => 'aix', :release => "#{$2}.#{$1}", :arch => $3, :oslevel => "#{oslevel}", :edition => "#{edition}" }
      else
        if run_command('ioslevel').success?
          oslevel = run_command('ioslevel').stdout.chomp
          edition = run_command('chedition -list').stdout.chomp
          { :family => 'aix', :release => nil, :arch => 'vios', :oslevel => "#{oslevel}", :edition => "#{edition}" }
        else
          { :family => 'aix', :release => nil, :arch => nil, :oslevel => nil, :edition => nil }
        end
      end
    end
  end
end
