class Specinfra::Command::Fedora::Base::Service < Specinfra::Command::Redhat::Base::Service
  def self.create
    if os[:release].to_i < 15
      self.new
    else
      Specinfra::Command::Fedora::V15::Service.new
    end
  end
end

