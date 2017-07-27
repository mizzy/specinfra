class Specinfra::Command::Freebsd::Base::Group < Specinfra::Command::Base::Group
  class << self
    def update_gid(group, gid)
      "pw groupmod #{escape(group)} -g #{escape(gid)}"
    end

    def add(group, options)
      command = %w[pw group add]
      command << escape(group)
      command << '-g' << escape(options[:gid])  if options[:gid]
      command.join(' ')
    end
  end
end
