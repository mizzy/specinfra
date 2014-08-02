class Specinfra::Command::Windows::Base
  class << self
    def create
      self
    end

    private
    def windows_account account
      match = /((.+)\\)?(.+)/.match account
      domain = match[2]
      name = match[3]
      [name, domain]
    end
  end
end
