class Specinfra::Command::Windows::Base
  def self.create
    self.new
  end

  private
  def windows_account account
    match = /((.+)\\)?(.+)/.match account
    domain = match[2]
    name = match[3]
    [name, domain]
  end

end
