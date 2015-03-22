require 'specinfra'
require 'pp'

a = Specinfra::Backend::Exec.new

ssh_options = Net::SSH::Config.for(ENV['SSH_HOST'], [ENV['SSH_CONFIG']])
b = Specinfra::Backend::Ssh.new(
  :host => ssh_options[:host_name],
  :ssh_options => ssh_options,
)

threads = [a, b].map do |backend|
  Thread.start(backend) do |backend|
    result = []
    result << backend.run_command("uname -a")
    result << backend.command
    result << backend.command.get(:install_package, 'dstat')
    result
  end
end

threads.each(&:join)
threads.each do |t|
  pp t.value
end

# example:
# [#<Specinfra::CommandResult:0x007fb3b1352e30
#   @exit_signal=nil,
#   @exit_status=0,
#   @stderr="",
#   @stdout=
#    "Darwin p411 14.1.0 Darwin Kernel Version 14.1.0: Thu Feb 26 19:26:47 PST 2015; root:xnu-2782.10.73~1/RELEASE_X86_64 x86_64\n">,
#  #<Specinfra::CommandFactory:0x007fb3b1153508
#   @os_info={:family=>"darwin", :release=>nil, :arch=>"x86_64"}>,
#  "/usr/local/bin/brew install  'dstat'"]
# [#<Specinfra::CommandResult:0x007fb3b0b9c2e0
#   @exit_signal=nil,
#   @exit_status=0,
#   @stderr="",
#   @stdout=
#    "Linux itamae-trusty 3.13.0-39-generic #66-Ubuntu SMP Tue Oct 28 13:30:27 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux\n">,
#  #<Specinfra::CommandFactory:0x007fb3b0d4d4b8
#   @os_info={:family=>"ubuntu", :release=>"14.04", :arch=>"x86_64"}>,
#  "DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'  install dstat"]

