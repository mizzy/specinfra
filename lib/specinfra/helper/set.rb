module Specinfra::Helper::Set
  def set(param, *value)
    Specinfra.configuration.send("#{param}=", *value)
  end
end
